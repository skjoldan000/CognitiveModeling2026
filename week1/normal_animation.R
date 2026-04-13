library(gganimate)
library(patchwork)
library(av)

n_iter <- 99
n_ids <- 99

n_toss <- n_iter*n_ids

d <- expand_grid(
  iter = 1:n_iter,
  id = 1:n_ids,
) %>%
  mutate(
    obs = c(rep(0, n_ids), sample(c(-1, 1), size = n()-n_ids, replace = TRUE))
  ) %>%
  group_by(id) %>%
  mutate(
    cum_obs = cumsum(obs)
  )
  

p_walk <- ggplot(d, aes(cum_obs, factor(id), group = id)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_point(size = 2) +
  coord_cartesian(xlim = c(-30, 30)) +
  labs(
    title = "Iteration: {closest_state}"
  ) +
  transition_states(
    iter,
    transition_length = 1,
    state_length = 2   # <- this creates the pause
  )+
  ease_aes("linear")

animate(
  p_walk,
  nframes = n_iter*1,
  fps = 3,
  renderer = av_renderer("random_walk.mp4")
)

p_hist <- d %>% 
  filter(iter == n_iter) %>% 
  ggplot(aes(cum_obs)) +
  geom_histogram(
    aes(y = after_stat(density)),
    binwidth = 2,
    fill = "steelblue",
    color = "white"
  ) +
  coord_cartesian(xlim = c(-30, 30))+
  labs(title = str_glue("Iteration: {n_iter}"))+
  geom_line(data = tibble(x = seq(-30,30), y = dnorm(x, sd = sqrt(n_iter))),aes(x = x, y = y))

p_hist
