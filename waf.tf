resource "aws_wafv2_web_acl" "this" {
  name        = format("%s-%s-waf", local.prefix, var.name)
  description = "WAFv2 ACL for ${var.name}"

  scope = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
    sampled_requests_enabled   = var.is_enable_sampled_requests
    metric_name                = "All"
  }

  dynamic "rule" {
    for_each = local.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"

          dynamic "excluded_rule" {
            for_each = rule.value.excluded_rules
            content {
              name = excluded_rule.value
            }
          }

          dynamic "scope_down_statement" {
            for_each = rule.value.scope_down_statements
            content {
              # scope down byte_match_statement
              dynamic "byte_match_statement" {
                for_each = length(lookup(scope_down_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "byte_match_statement", {})]
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                    content {
                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                        content {}
                      }
                      dynamic "all_query_arguments" {
                        for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                        content {}
                      }
                      dynamic "body" {
                        for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                        content {}
                      }
                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                        content {}
                      }
                      dynamic "query_string" {
                        for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                        content {}
                      }
                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                        content {
                          name = lower(lookup(single_header.value, "name"))
                        }
                      }
                    }
                  }
                  positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                  search_string         = lookup(byte_match_statement.value, "search_string")
                  text_transformation {
                    priority = lookup(byte_match_statement.value, "priority")
                    type     = lookup(byte_match_statement.value, "type")
                  }
                }
              }
              # scope down geo_match_statement
              dynamic "geo_match_statement" {
                for_each = length(lookup(scope_down_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "geo_match_statement", {})]
                content {
                  country_codes = lookup(geo_match_statement.value, "country_codes")
                  dynamic "forwarded_ip_config" {
                    for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                    content {
                      fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                      header_name       = lookup(forwarded_ip_config.value, "header_name")
                    }
                  }
                }
              }

              # scope down NOT statements
              dynamic "not_statement" {
                for_each = length(lookup(scope_down_statement.value, "not_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "not_statement", {})]
                content {
                  statement {
                    # Scope down AND ip_set_statement
                    dynamic "ip_set_reference_statement" {
                      for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "ip_set_reference_statement", {})]
                      content {
                        arn = lookup(ip_set_reference_statement.value, "arn")
                      }
                    }
                    # scope down NOT byte_match_statement
                    dynamic "byte_match_statement" {
                      for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                      content {
                        dynamic "field_to_match" {
                          for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                          content {
                            dynamic "uri_path" {
                              for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                              content {}
                            }
                            dynamic "all_query_arguments" {
                              for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                              content {}
                            }
                            dynamic "body" {
                              for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                              content {}
                            }
                            dynamic "method" {
                              for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                              content {}
                            }
                            dynamic "query_string" {
                              for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                              content {}
                            }
                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                              content {
                                name = lower(lookup(single_header.value, "name"))
                              }
                            }
                          }
                        }
                        positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                        search_string         = lookup(byte_match_statement.value, "search_string")
                        text_transformation {
                          priority = lookup(byte_match_statement.value, "priority")
                          type     = lookup(byte_match_statement.value, "type")
                        }
                      }
                    }

                    # scope down NOT geo_match_statement
                    dynamic "geo_match_statement" {
                      for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                      content {
                        country_codes = lookup(geo_match_statement.value, "country_codes")
                        dynamic "forwarded_ip_config" {
                          for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                          content {
                            fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                            header_name       = lookup(forwarded_ip_config.value, "header_name")
                          }
                        }
                      }
                    }

                    #scope down NOT regex_pattern_set_reference_statement
                    dynamic "regex_pattern_set_reference_statement" {
                      for_each = length(lookup(not_statement.value, "regex_pattern_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "regex_pattern_set_reference_statement", {})]
                      content {
                        arn = lookup(regex_pattern_set_reference_statement.value, "arn")
                        dynamic "field_to_match" {
                          for_each = length(lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})]
                          content {
                            dynamic "uri_path" {
                              for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                              content {}
                            }
                            dynamic "all_query_arguments" {
                              for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                              content {}
                            }
                            dynamic "body" {
                              for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                              content {}
                            }
                            dynamic "method" {
                              for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                              content {}
                            }
                            dynamic "query_string" {
                              for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                              content {}
                            }
                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                              content {
                                name = lower(lookup(single_header.value, "name"))
                              }
                            }
                          }
                        }
                        text_transformation {
                          priority = lookup(regex_pattern_set_reference_statement.value, "priority")
                          type     = lookup(regex_pattern_set_reference_statement.value, "type")
                        }
                      }
                    }
                  }
                }
              }

              ### scope down AND statements (Requires at least two statements)
              dynamic "and_statement" {
                for_each = length(lookup(scope_down_statement.value, "and_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "and_statement", {})]
                content {

                  dynamic "statement" {
                    for_each = lookup(and_statement.value, "statements", {})
                    content {
                      # Scope down AND byte_match_statement
                      dynamic "byte_match_statement" {
                        for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                        content {
                          dynamic "field_to_match" {
                            for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                            content {
                              dynamic "uri_path" {
                                for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                content {}
                              }
                              dynamic "all_query_arguments" {
                                for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                content {}
                              }
                              dynamic "body" {
                                for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                content {}
                              }
                              dynamic "method" {
                                for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                content {}
                              }
                              dynamic "query_string" {
                                for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                content {}
                              }
                              dynamic "single_header" {
                                for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                content {
                                  name = lower(lookup(single_header.value, "name"))
                                }
                              }
                            }
                          }
                          positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                          search_string         = lookup(byte_match_statement.value, "search_string")
                          text_transformation {
                            priority = lookup(byte_match_statement.value, "priority")
                            type     = lookup(byte_match_statement.value, "type")
                          }
                        }
                      }

                      # Scope down AND geo_match_statement
                      dynamic "geo_match_statement" {
                        for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                        content {
                          country_codes = lookup(geo_match_statement.value, "country_codes")
                          dynamic "forwarded_ip_config" {
                            for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                            content {
                              fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                              header_name       = lookup(forwarded_ip_config.value, "header_name")
                            }
                          }
                        }
                      }

                      # Scope down AND ip_set_statement
                      dynamic "ip_set_reference_statement" {
                        for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                        content {
                          arn = lookup(ip_set_reference_statement.value, "arn")
                        }
                      }

                      #scope down AND regex_pattern_set_reference_statement
                      dynamic "regex_pattern_set_reference_statement" {
                        for_each = length(lookup(statement.value, "regex_pattern_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "regex_pattern_set_reference_statement", {})]
                        content {
                          arn = lookup(regex_pattern_set_reference_statement.value, "arn")
                          dynamic "field_to_match" {
                            for_each = length(lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})]
                            content {
                              dynamic "uri_path" {
                                for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                content {}
                              }
                              dynamic "all_query_arguments" {
                                for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                content {}
                              }
                              dynamic "body" {
                                for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                content {}
                              }
                              dynamic "method" {
                                for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                content {}
                              }
                              dynamic "query_string" {
                                for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                content {}
                              }
                              dynamic "single_header" {
                                for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                content {
                                  name = lower(lookup(single_header.value, "name"))
                                }
                              }
                            }
                          }
                          text_transformation {
                            priority = lookup(regex_pattern_set_reference_statement.value, "priority")
                            type     = lookup(regex_pattern_set_reference_statement.value, "type")
                          }
                        }
                      }

                      dynamic "not_statement" {
                        for_each = length(lookup(statement.value, "not_statement", {})) == 0 ? [] : [lookup(statement.value, "not_statement", {})]
                        content {
                          statement {
                            # Scope down NOT ip_set_statement
                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "ip_set_reference_statement", {})]
                              content {
                                arn = lookup(ip_set_reference_statement.value, "arn")
                              }
                            }
                            # scope down NOT byte_match_statement
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                                  content {
                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                      content {}
                                    }
                                    dynamic "all_query_arguments" {
                                      for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                      content {}
                                    }
                                    dynamic "body" {
                                      for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                      content {}
                                    }
                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                      content {}
                                    }
                                    dynamic "query_string" {
                                      for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                      content {}
                                    }
                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                      content {
                                        name = lower(lookup(single_header.value, "name"))
                                      }
                                    }
                                  }
                                }
                                positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                                search_string         = lookup(byte_match_statement.value, "search_string")
                                text_transformation {
                                  priority = lookup(byte_match_statement.value, "priority")
                                  type     = lookup(byte_match_statement.value, "type")
                                }
                              }
                            }

                            # scope down NOT geo_match_statement
                            dynamic "geo_match_statement" {
                              for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                              content {
                                country_codes = lookup(geo_match_statement.value, "country_codes")
                                dynamic "forwarded_ip_config" {
                                  for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                                  content {
                                    fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                    header_name       = lookup(forwarded_ip_config.value, "header_name")
                                  }
                                }
                              }
                            }

                            # Scope down NOT label_match_statement
                            dynamic "label_match_statement" {
                              for_each = length(lookup(not_statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "label_match_statement", {})]
                              content {
                                key   = lookup(label_match_statement.value, "key")
                                scope = lookup(label_match_statement.value, "scope")
                              }
                            }

                            #scope down NOT regex_pattern_set_reference_statement
                            dynamic "regex_pattern_set_reference_statement" {
                              for_each = length(lookup(not_statement.value, "regex_pattern_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "regex_pattern_set_reference_statement", {})]
                              content {
                                arn = lookup(regex_pattern_set_reference_statement.value, "arn")
                                dynamic "field_to_match" {
                                  for_each = length(lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})]
                                  content {
                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                      content {}
                                    }
                                    dynamic "all_query_arguments" {
                                      for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                      content {}
                                    }
                                    dynamic "body" {
                                      for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                      content {}
                                    }
                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                      content {}
                                    }
                                    dynamic "query_string" {
                                      for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                      content {}
                                    }
                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                      content {
                                        name = lower(lookup(single_header.value, "name"))
                                      }
                                    }
                                  }
                                }
                                text_transformation {
                                  priority = lookup(regex_pattern_set_reference_statement.value, "priority")
                                  type     = lookup(regex_pattern_set_reference_statement.value, "type")
                                }
                              }
                            }
                          }
                        }
                      }


                      }
                    }
                  }
                }


                ### scope down OR statements (Requires at least two statements)
                dynamic "or_statement" {
                  for_each = length(lookup(scope_down_statement.value, "or_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "or_statement", {})]
                  content {

                    dynamic "statement" {
                      for_each = lookup(or_statement.value, "statements", {})
                      content {
                        # Scope down OR byte_match_statement
                        dynamic "byte_match_statement" {
                          for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                          content {
                            dynamic "field_to_match" {
                              for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                              content {
                                dynamic "uri_path" {
                                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                  content {}
                                }
                                dynamic "all_query_arguments" {
                                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                  content {}
                                }
                                dynamic "body" {
                                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                  content {}
                                }
                                dynamic "method" {
                                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                  content {}
                                }
                                dynamic "query_string" {
                                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                  content {}
                                }
                                dynamic "single_header" {
                                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                  content {
                                    name = lower(lookup(single_header.value, "name"))
                                  }
                                }
                              }
                            }
                            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                            search_string         = lookup(byte_match_statement.value, "search_string")
                            text_transformation {
                              priority = lookup(byte_match_statement.value, "priority")
                              type     = lookup(byte_match_statement.value, "type")
                            }
                          }
                        }

                        # Scope down OR geo_match_statement
                        dynamic "geo_match_statement" {
                          for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                          content {
                            country_codes = lookup(geo_match_statement.value, "country_codes")
                            dynamic "forwarded_ip_config" {
                              for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                              content {
                                fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                header_name       = lookup(forwarded_ip_config.value, "header_name")
                              }
                            }
                          }
                        }

                        # Scope down OR ip_set_statement
                        dynamic "ip_set_reference_statement" {
                          for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                          content {
                            arn = lookup(ip_set_reference_statement.value, "arn")
                          }
                        }

                        #scope down OR regex_pattern_set_reference_statement
                        dynamic "regex_pattern_set_reference_statement" {
                          for_each = length(lookup(statement.value, "regex_pattern_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "regex_pattern_set_reference_statement", {})]
                          content {
                            arn = lookup(regex_pattern_set_reference_statement.value, "arn")
                            dynamic "field_to_match" {
                              for_each = length(lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})]
                              content {
                                dynamic "uri_path" {
                                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                  content {}
                                }
                                dynamic "all_query_arguments" {
                                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                  content {}
                                }
                                dynamic "body" {
                                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                  content {}
                                }
                                dynamic "method" {
                                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                  content {}
                                }
                                dynamic "query_string" {
                                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                  content {}
                                }
                                dynamic "single_header" {
                                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                  content {
                                    name = lower(lookup(single_header.value, "name"))
                                  }
                                }
                              }
                            }
                            text_transformation {
                              priority = lookup(regex_pattern_set_reference_statement.value, "priority")
                              type     = lookup(regex_pattern_set_reference_statement.value, "type")
                            }
                          }
                        }
                      }
                    }
                  }
                }  
              # Scope down label_match_statement
              dynamic "label_match_statement" {
                for_each = length(lookup(scope_down_statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "label_match_statement", {})]
                content {
                  key   = lookup(label_match_statement.value, "key")
                  scope = lookup(label_match_statement.value, "scope")
                }
              }

            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }



  dynamic "rule" {
    for_each = var.ip_sets_rule
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.ipset[index(var.ip_sets_rule, rule.value)].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }


  dynamic "rule" {
    for_each = var.rate_based_statement_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
              //for_each = length(lookup(rule.value, "rate_based_statement", {})) == 0 ? [] : [lookup(rule.value, "rate_based_statement", {})]
              //content {
                limit              = lookup(rule.value, "limit")
                aggregate_key_type = lookup(rule.value, "aggregate_key_type", "IP")

                dynamic "forwarded_ip_config" {
                  for_each = length(lookup(rule.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(rule.value, "forwarded_ip_config", {})]
                  content {
                    fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                    header_name       = lookup(forwarded_ip_config.value, "header_name")
                  }
                }

                dynamic "scope_down_statement" {
                  for_each = rule.value.scope_down_statements
                  content {
                    # scope down byte_match_statement
                    dynamic "byte_match_statement" {
                      for_each = length(lookup(scope_down_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "byte_match_statement", {})]
                      content {
                        dynamic "field_to_match" {
                          for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                          content {
                            dynamic "uri_path" {
                              for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                              content {}
                            }
                            dynamic "all_query_arguments" {
                              for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                              content {}
                            }
                            dynamic "body" {
                              for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                              content {}
                            }
                            dynamic "method" {
                              for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                              content {}
                            }
                            dynamic "query_string" {
                              for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                              content {}
                            }
                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                              content {
                                name = lower(lookup(single_header.value, "name"))
                              }
                            }
                          }
                        }
                        positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                        search_string         = lookup(byte_match_statement.value, "search_string")
                        text_transformation {
                          priority = lookup(byte_match_statement.value, "priority")
                          type     = lookup(byte_match_statement.value, "type")
                        }
                      }
                    }

                    # scope down geo_match_statement
                    dynamic "geo_match_statement" {
                      for_each = length(lookup(scope_down_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "geo_match_statement", {})]
                      content {
                        country_codes = lookup(geo_match_statement.value, "country_codes")
                        dynamic "forwarded_ip_config" {
                          for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                          content {
                            fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                            header_name       = lookup(forwarded_ip_config.value, "header_name")
                          }
                        }
                      }
                    }

                    # scope down label_match_statement
                    dynamic "label_match_statement" {
                      for_each = length(lookup(scope_down_statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "label_match_statement", {})]
                      content {
                        key   = lookup(label_match_statement.value, "key")
                        scope = lookup(label_match_statement.value, "scope")
                      }
                    }

                    #scope down regex_pattern_set_reference_statement
                    dynamic "regex_pattern_set_reference_statement" {
                      for_each = length(lookup(scope_down_statement.value, "regex_pattern_set_reference_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "regex_pattern_set_reference_statement", {})]
                      content {
                        arn = lookup(regex_pattern_set_reference_statement.value, "arn")
                        dynamic "field_to_match" {
                          for_each = length(lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(regex_pattern_set_reference_statement.value, "field_to_match", {})]
                          content {
                            dynamic "uri_path" {
                              for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                              content {}
                            }
                            dynamic "all_query_arguments" {
                              for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                              content {}
                            }
                            dynamic "body" {
                              for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                              content {}
                            }
                            dynamic "method" {
                              for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                              content {}
                            }
                            dynamic "query_string" {
                              for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                              content {}
                            }
                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                              content {
                                name = lower(lookup(single_header.value, "name"))
                              }
                            }
                          }
                        }
                        text_transformation {
                          priority = lookup(regex_pattern_set_reference_statement.value, "priority")
                          type     = lookup(regex_pattern_set_reference_statement.value, "type")
                        }
                      }
                    }

                    # scope down NOT statements
                    dynamic "not_statement" {
                      for_each = length(lookup(scope_down_statement.value, "not_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "not_statement", {})]
                      content {
                        statement {
                          # Scope down NOT ip_set_statement
                          dynamic "ip_set_reference_statement" {
                            for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "ip_set_reference_statement", {})]
                            content {
                              arn = lookup(ip_set_reference_statement.value, "arn")
                            }
                          }
                          # scope down NOT byte_match_statement
                          dynamic "byte_match_statement" {
                            for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                            content {
                              dynamic "field_to_match" {
                                for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                                content {
                                  dynamic "uri_path" {
                                    for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                    content {}
                                  }
                                  dynamic "all_query_arguments" {
                                    for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                    content {}
                                  }
                                  dynamic "body" {
                                    for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                    content {}
                                  }
                                  dynamic "method" {
                                    for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                    content {}
                                  }
                                  dynamic "query_string" {
                                    for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                    content {}
                                  }
                                  dynamic "single_header" {
                                    for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                    content {
                                      name = lower(lookup(single_header.value, "name"))
                                    }
                                  }
                                }
                              }
                              positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                              search_string         = lookup(byte_match_statement.value, "search_string")
                              text_transformation {
                                priority = lookup(byte_match_statement.value, "priority")
                                type     = lookup(byte_match_statement.value, "type")
                              }
                            }
                          }

                          # scope down NOT geo_match_statement
                          dynamic "geo_match_statement" {
                            for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                            content {
                              country_codes = lookup(geo_match_statement.value, "country_codes")
                              dynamic "forwarded_ip_config" {
                                for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                                content {
                                  fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                  header_name       = lookup(forwarded_ip_config.value, "header_name")
                                }
                              }
                            }
                          }

                          # Scope down NOT label_match_statement
                          dynamic "label_match_statement" {
                            for_each = length(lookup(not_statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "label_match_statement", {})]
                            content {
                              key   = lookup(label_match_statement.value, "key")
                              scope = lookup(label_match_statement.value, "scope")
                            }
                          }
                        }
                      }
                    }

                    ### scope down AND statements (Requires at least two statements)
                    dynamic "and_statement" {
                      for_each = length(lookup(scope_down_statement.value, "and_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "and_statement", {})]
                      content {

                        dynamic "statement" {
                          for_each = lookup(and_statement.value, "statements", {})
                          content {
                            # Scope down AND byte_match_statement
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                                  content {
                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                      content {}
                                    }
                                    dynamic "all_query_arguments" {
                                      for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                      content {}
                                    }
                                    dynamic "body" {
                                      for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                      content {}
                                    }
                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                      content {}
                                    }
                                    dynamic "query_string" {
                                      for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                      content {}
                                    }
                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                      content {
                                        name = lower(lookup(single_header.value, "name"))
                                      }
                                    }
                                  }
                                }
                                positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                                search_string         = lookup(byte_match_statement.value, "search_string")
                                text_transformation {
                                  priority = lookup(byte_match_statement.value, "priority")
                                  type     = lookup(byte_match_statement.value, "type")
                                }
                              }
                            }

                            # Scope down AND geo_match_statement
                            dynamic "geo_match_statement" {
                              for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                              content {
                                country_codes = lookup(geo_match_statement.value, "country_codes")
                                dynamic "forwarded_ip_config" {
                                  for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                                  content {
                                    fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                    header_name       = lookup(forwarded_ip_config.value, "header_name")
                                  }
                                }
                              }
                            }

                            # Scope down AND ip_set_statement
                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                              content {
                                arn = lookup(ip_set_reference_statement.value, "arn")
                              }
                            }

                            # Scope down AND label_match_statement
                            dynamic "label_match_statement" {
                              for_each = length(lookup(statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(statement.value, "label_match_statement", {})]
                              content {
                                key   = lookup(label_match_statement.value, "key")
                                scope = lookup(label_match_statement.value, "scope")
                              }
                            }

                            # Scope down AND not_statement

                            #scope_down -> and_Statement -> statement -> not_statement -> statement -> ip_set


                            dynamic "not_statement" {
                              for_each = length(lookup(statement.value, "not_statement", {})) == 0 ? [] : [lookup(statement.value, "not_statement", {})]
                              content {
                                statement {
                                  # Scope down NOT ip_set_statement
                                  dynamic "ip_set_reference_statement" {
                                    for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "ip_set_reference_statement", {})]
                                    content {
                                      arn = lookup(ip_set_reference_statement.value, "arn")
                                    }
                                  }
                                  # scope down NOT byte_match_statement
                                  dynamic "byte_match_statement" {
                                    for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                                    content {
                                      dynamic "field_to_match" {
                                        for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                                        content {
                                          dynamic "uri_path" {
                                            for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                            content {}
                                          }
                                          dynamic "all_query_arguments" {
                                            for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                            content {}
                                          }
                                          dynamic "body" {
                                            for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                            content {}
                                          }
                                          dynamic "method" {
                                            for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                            content {}
                                          }
                                          dynamic "query_string" {
                                            for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                            content {}
                                          }
                                          dynamic "single_header" {
                                            for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                            content {
                                              name = lower(lookup(single_header.value, "name"))
                                            }
                                          }
                                        }
                                      }
                                      positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                                      search_string         = lookup(byte_match_statement.value, "search_string")
                                      text_transformation {
                                        priority = lookup(byte_match_statement.value, "priority")
                                        type     = lookup(byte_match_statement.value, "type")
                                      }
                                    }
                                  }

                                  # scope down NOT geo_match_statement
                                  dynamic "geo_match_statement" {
                                    for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                                    content {
                                      country_codes = lookup(geo_match_statement.value, "country_codes")
                                      dynamic "forwarded_ip_config" {
                                        for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                                        content {
                                          fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                          header_name       = lookup(forwarded_ip_config.value, "header_name")
                                        }
                                      }
                                    }
                                  }

                                  # Scope down NOT label_match_statement
                                  dynamic "label_match_statement" {
                                    for_each = length(lookup(not_statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "label_match_statement", {})]
                                    content {
                                      key   = lookup(label_match_statement.value, "key")
                                      scope = lookup(label_match_statement.value, "scope")
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }

                    ### scope down OR statements (Requires at least two statements)
                    dynamic "or_statement" {
                      for_each = length(lookup(scope_down_statement.value, "or_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "or_statement", {})]
                      content {

                        dynamic "statement" {
                          for_each = lookup(or_statement.value, "statements", {})
                          content {
                            # Scope down OR byte_match_statement
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                                  content {
                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                      content {}
                                    }
                                    dynamic "all_query_arguments" {
                                      for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                      content {}
                                    }
                                    dynamic "body" {
                                      for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                      content {}
                                    }
                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                      content {}
                                    }
                                    dynamic "query_string" {
                                      for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                      content {}
                                    }
                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                      content {
                                        name = lower(lookup(single_header.value, "name"))
                                      }
                                    }
                                  }
                                }
                                positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                                search_string         = lookup(byte_match_statement.value, "search_string")
                                text_transformation {
                                  priority = lookup(byte_match_statement.value, "priority")
                                  type     = lookup(byte_match_statement.value, "type")
                                }
                              }
                            }

                            # Scope down OR geo_match_statement
                            dynamic "geo_match_statement" {
                              for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                              content {
                                country_codes = lookup(geo_match_statement.value, "country_codes")
                                dynamic "forwarded_ip_config" {
                                  for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                                  content {
                                    fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                    header_name       = lookup(forwarded_ip_config.value, "header_name")
                                  }
                                }
                              }
                            }

                            # Scope down OR ip_set_statement
                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                              content {
                                arn = lookup(ip_set_reference_statement.value, "arn")
                              }
                            }

                            # Scope down OR label_match_statement
                            dynamic "label_match_statement" {
                              for_each = length(lookup(statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(statement.value, "label_match_statement", {})]
                              content {
                                key   = lookup(label_match_statement.value, "key")
                                scope = lookup(label_match_statement.value, "scope")
                              }
                            }

                            # Scope down OR not_statement
                            dynamic "not_statement" {
                              for_each = length(lookup(statement.value, "not_statement", {})) == 0 ? [] : [lookup(statement.value, "not_statement", {})]
                              content {
                                statement {
                                  # scope down NOT byte_match_statement
                                  dynamic "byte_match_statement" {
                                    for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                                    content {
                                      dynamic "field_to_match" {
                                        for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                                        content {
                                          dynamic "uri_path" {
                                            for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                            content {}
                                          }
                                          dynamic "all_query_arguments" {
                                            for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                            content {}
                                          }
                                          dynamic "body" {
                                            for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                            content {}
                                          }
                                          dynamic "method" {
                                            for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                            content {}
                                          }
                                          dynamic "query_string" {
                                            for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                            content {}
                                          }
                                          dynamic "single_header" {
                                            for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                            content {
                                              name = lower(lookup(single_header.value, "name"))
                                            }
                                          }
                                        }
                                      }
                                      positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                                      search_string         = lookup(byte_match_statement.value, "search_string")
                                      text_transformation {
                                        priority = lookup(byte_match_statement.value, "priority")
                                        type     = lookup(byte_match_statement.value, "type")
                                      }
                                    }
                                  }

                                  # scope down NOT geo_match_statement
                                  dynamic "geo_match_statement" {
                                    for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                                    content {
                                      country_codes = lookup(geo_match_statement.value, "country_codes")
                                      dynamic "forwarded_ip_config" {
                                        for_each = length(lookup(geo_match_statement.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(geo_match_statement.value, "forwarded_ip_config", {})]
                                        content {
                                          fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                                          header_name       = lookup(forwarded_ip_config.value, "header_name")
                                        }
                                      }
                                    }
                                  }

                                  # Scope down NOT label_match_statement
                                  dynamic "label_match_statement" {
                                    for_each = length(lookup(not_statement.value, "label_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "label_match_statement", {})]
                                    content {
                                      key   = lookup(label_match_statement.value, "key")
                                      scope = lookup(label_match_statement.value, "scope")
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                //}
              }
            }
      }
      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }



  dynamic "rule" {
    for_each = var.regex_pattern_set_reference_statement_rules != null ? [var.regex_pattern_set_reference_statement_rules] : []
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        regex_pattern_set_reference_statement {
            arn = rule.value.statement.value.arn

            dynamic "field_to_match" {
              for_each = lookup(rule.value.statement, "field_to_match", null) != null ? [rule.value.statement.field_to_match] : []

              content {
                dynamic "all_query_arguments" {
                  for_each = lookup(field_to_match.value, "all_query_arguments", null) != null ? [1] : []

                  content {}
                }

                dynamic "body" {
                  for_each = lookup(field_to_match.value, "body", null) != null ? [1] : []

                  content {}
                }

                dynamic "method" {
                  for_each = lookup(field_to_match.value, "method", null) != null ? [1] : []

                  content {}
                }

                dynamic "query_string" {
                  for_each = lookup(field_to_match.value, "query_string", null) != null ? [1] : []

                  content {}
                }

                dynamic "single_header" {
                  for_each = lookup(field_to_match.value, "single_header", null) != null ? [field_to_match.value.single_header] : []

                  content {
                    name = single_header.value.name
                  }
                }

                dynamic "single_query_argument" {
                  for_each = lookup(field_to_match.value, "single_query_argument", null) != null ? [field_to_match.value.single_query_argument] : []

                  content {
                    name = single_query_argument.value.name
                  }
                }

                dynamic "uri_path" {
                  for_each = lookup(field_to_match.value, "uri_path", null) != null ? [1] : []

                  content {}
                }
              }
            }

            dynamic "text_transformation" {
              for_each = lookup(rule.value.statement, "text_transformation", null) != null ? [
                for rule in lookup(rule.value.statement, "text_transformation") : {
                  priority = rule.priority
                  type     = rule.type
              }] : []

              content {
                priority = text_transformation.value.priority
                type     = text_transformation.value.type
              }
            }
          }
        }
      }
      visibility_config {
          cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
          metric_name                = rule.value.name
          sampled_requests_enabled   = var.is_enable_sampled_requests
      }
  }

  dynamic "rule" {
    for_each = var.ip_rate_based_rule != null ? [var.ip_rate_based_rule] : []
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }

  tags = merge(
    local.tags,
    { "Name" = format("%s-%s", local.prefix, var.name) }
  )
  depends_on = [
    aws_wafv2_ip_set.ipset,
  ]
}

resource "aws_wafv2_web_acl_association" "this" {
  count = length(var.association_resources)

  resource_arn = var.association_resources[count.index]
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
