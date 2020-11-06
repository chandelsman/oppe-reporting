reports <- tibble(
    grp = unique(ta_time$grp),
    filename = stringr::str_c("2020-Q1-turnaround-", grp, ".html"),
    params = purrr::map(class, ~list(grp = .))
)

reports %>% 
  select(output_file = filename, params) %>%
  purrr::pwalk(rmarkdown::render, input = "./R/turnaround_time_report.Rmd")

  
class <- mpg %>% filter(class == params$my_class)

mpg$class
