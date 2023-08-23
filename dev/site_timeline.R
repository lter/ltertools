
site_long <- lter_sites %>%
  tidyr::pivot_longer(cols = ends_with("_year"), names_to = "cols", values_to = "year")

ggplot(site_long, aes(x = year, y = factor(code, levels = lter_sites$code))) +
  geom_path(aes(group = code, color = habitat), lwd = 1, lineend = 'round') +
  geom_point(aes(fill = habitat), pch = 21, size = 2)