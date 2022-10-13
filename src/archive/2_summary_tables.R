
# Client group table ------------------------------------------------------

ta_time %>% 
  filter(cl_grp == "UC Health South") %>% 
  summarize(
    Cases = n(),
    Average = mean(span),
    `Under 48 hrs` = sum(span <= 48) / n()
  ) %>% 
  gt(auto_align = TRUE) %>% 
  tab_header (title = "UC Health South",
              subtitle = "Turnaround Time: 2020 Quarter 1") %>% 
  fmt_number(
    columns = vars(Cases),
    decimals = 0,
    use_seps = TRUE
  ) %>% 
  fmt_number(
    columns = vars(Average),
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  fmt_percent(
    columns = vars(`Under 48 hrs`),
    decimals = 1,
    use_seps = T
  ) %>% 
  cols_align(
    align = "right"
  ) %>% 
  tab_options(
    row_group.background.color = "lightgray",
    # row_group.font.weight = "bold",
    # column_labels.font.weight = "bold",
    table.width = pct(50)
  ) 



# Facility table ----------------------------------------------------------

ta_time %>% 
  filter(cl_grp == "UC Health South") %>% 
  group_by(client, type) %>% 
  summarize(
    Cases = n(),
    Average = mean(span),
    `Under 48 hrs` = sum(span <= 48) / n()
  ) %>% 
  gt(rowname_col = "type", auto_align = TRUE) %>% 
  tab_header (title = "",
    subtitle = "Facility Statistics"
    ) %>% 
  fmt_number(
    columns = vars(Cases),
    decimals = 0,
    use_seps = TRUE
  ) %>% 
  fmt_number(
    columns = vars(Average),
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  fmt_percent(
    columns = vars(`Under 48 hrs`),
    decimals = 1,
    use_seps = T
  ) %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(Cases),
    fns = list(Overall = "sum"),
    formatter = fmt_number,
    decimals = 0,
    use_seps = TRUE
  ) %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(Average),
    fns = list(Overall = "mean"),
    formatter = fmt_number,
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(`Under 48 hrs`),
    fns = list(Overall = "mean"),
    formatter = fmt_percent,
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  cols_align(
    align = "right"
  ) %>% 
  tab_options(
    row_group.background.color = "lightgray",
    # row_group.font.weight = "bold",
    # column_labels.font.weight = "bold",
    table.width = pct(50)
  ) 


# Pathologist table -------------------------------------------------------

ta_time %>% 
  filter(cl_grp == "UC Health South") %>% 
  group_by(PATHOLOGIST, type) %>% 
  summarize(
    Cases = n(),
    Average = mean(span),
    `Under 48 hrs` = sum(span <= 48) / n()
  ) %>%
  gt(rowname_col = "type", auto_align = TRUE) %>% 
  tab_header (title = "",
              subtitle = "Pathologist Statistics") %>% 
  fmt_number(
    columns = vars(Cases),
    decimals = 0,
    use_seps = TRUE
  ) %>% 
  fmt_number(
    columns = vars(Average),
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  fmt_percent(
    columns = vars(`Under 48 hrs`),
    decimals = 1,
    use_seps = T
  ) %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(Cases),
    fns = list(Overall = "sum"),
    formatter = fmt_number,
    decimals = 0,
    use_seps = TRUE
  ) %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(Average),
    fns = list(Overall = "mean"),
    formatter = fmt_number,
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(`Under 48 hrs`),
    fns = list(Overall = "mean"),
    formatter = fmt_percent,
    decimals = 1,
    use_seps = TRUE
  ) %>% 
  cols_align(
    align = "right"
    ) %>% 
  tab_options(
    
    # row_group.background.color = "lightgray",
    # row_group.font.weight = "bold",
    # column_labels.font.weight = "bold",
    table.width = pct(50),
    summary_row.background.color = "lightgray",
    summary_row.padding = px(5),
    row_group.font.weight = "bold",
    row_group.padding = px(15)
    ) 
