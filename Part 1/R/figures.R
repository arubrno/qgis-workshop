# Figures for Part 1 slides (Úvod do GIS)
# Run from the repository root:  Rscript "Part 1/R/figures.R"
# Output: Part 1/img/*.png

library(sf)
library(terra)
library(ggplot2)
library(patchwork)
library(HistData)
library(giscoR)

out <- file.path("Part 1", "img")
dir.create(out, showWarnings = FALSE)

save_fig <- function(p, name, w = 10, h = 5.625) {
  ggsave(file.path(out, name), p, width = w, height = h, dpi = 160, bg = "white")
}

theme_set(theme_void(base_size = 16))

col <- c(
  pole = "#f3eccf", les = "#8fbf7f", ves = "#d99a8c", reka = "#5b9bd5",
  cesta = "#6b5a48", mohyla = "#a0522d", nalez = "#d7301f", prospekce = "#e0a800"
)

# John Snow ---------------------------------------------------------------

# 1) original map without the legend (guessing game)
snow <- jpeg::readJPEG(file.path("Part 1", "01snow.jpg"))
snow <- if (length(dim(snow)) == 3) snow[-(1:70), , ] else snow[-(1:70), ]
png::writePNG(snow, file.path(out, "snow-cropped.png"))

# 2) deaths by nearest pump (Voronoi / Thiessen polygons)
deaths <- st_as_sf(Snow.deaths, coords = c("x", "y"))
pumps <- st_as_sf(Snow.pumps, coords = c("x", "y"))
streets <- lapply(split(Snow.streets, Snow.streets$street), \(s) st_linestring(as.matrix(s[, c("x", "y")])))
streets <- st_sf(geometry = st_sfc(streets))

frame <- st_as_sfc(st_bbox(streets))
cells <- st_voronoi(st_union(pumps), envelope = frame) |>
  st_collection_extract("POLYGON") |>
  st_intersection(frame) |>
  st_sf()
cells$n <- lengths(st_intersects(cells, deaths))
broad <- pumps[pumps$label == "Broad St", ]
cat("Deaths:", nrow(deaths), "| nearest to Broad St pump:", cells$n[lengths(st_intersects(cells, broad)) > 0], "\n")

p_snow <- ggplot() +
  geom_sf(data = cells, aes(fill = n), colour = "grey40", linewidth = 0.4) +
  geom_sf(data = streets, colour = "grey55", linewidth = 0.5) +
  geom_sf(data = deaths, size = 0.9, colour = "black") +
  geom_sf(data = pumps, shape = 4, size = 4, stroke = 1.6, colour = "#0b5394") +
  geom_sf(data = broad, shape = 21, size = 9, stroke = 1.4, colour = "#d7301f", fill = NA) +
  geom_sf_label(data = broad, aes(label = "pumpa Broad Street"), nudge_x = -1.5, nudge_y = -1.9, fill = "white",
                colour = "#d7301f", size = 5, linewidth = 0) +
  scale_fill_gradient("úmrtí\nv zóně", low = "white", high = "#f4a582") +
  coord_sf(expand = FALSE, datum = NA) +
  labs(caption = "Body = úmrtí, × = pumpy, plochy = území, ke kterému je daná pumpa nejblíž.\nData: HistData::Snow (podle J. Snowa 1854)") +
  theme(legend.position = "right", plot.caption = element_text(size = 11, hjust = 0))
save_fig(p_snow, "snow-pumps.png")

# Imaginary landscape -----------------------------------------------------
# Local metric coordinates (m), 1200 x 800 m.

set.seed(1854)
W <- 1200; H <- 800
ext_poly <- st_as_sfc(st_bbox(c(xmin = 0, ymin = 0, xmax = W, ymax = H)))

river_y <- function(x) 190 + 60 * sin(x / 150) + 20 * sin(x / 47)
xr <- seq(0, W, by = 5)
river <- st_sfc(st_linestring(cbind(xr, river_y(xr))))
road <- st_sfc(st_linestring(rbind(
  c(60, 800), c(250, 690), c(420, 560), c(560, 400), c(620, 250), c(680, 130), c(760, 0)
)))
road_side <- st_sfc(st_linestring(rbind(c(560, 400), c(760, 430), c(1000, 470), c(1200, 520))))

blob <- function(cx, cy, r, n = 40, noise = 0.18) {
  a <- seq(0, 2 * pi, length.out = n + 1)[-(n + 1)]
  rr <- r * (1 + noise * (sin(3 * a + runif(1, 0, 6)) + 0.6 * sin(5 * a + runif(1, 0, 6))) / 1.6)
  xy <- cbind(cx + rr * cos(a), cy + rr * sin(a))
  st_polygon(list(rbind(xy, xy[1, ])))
}
forest <- st_intersection(st_sfc(blob(230, 640, 230)), ext_poly)
village <- st_sfc(blob(700, 410, 105, noise = 0.25))
houses <- st_sfc(lapply(1:14, \(i) {
  repeat {
    p <- c(runif(1, 610, 790), runif(1, 330, 490))
    if (st_within(st_sfc(st_point(p)), village, sparse = FALSE)[1, 1]) break
  }
  st_polygon(list(rbind(p, p + c(16, 0), p + c(16, 11), p + c(0, 11), p)))
}))
mound_xy <- cbind(
  x = c(905, 940, 985, 1010, 1050, 1080, 1120, 960, 1030),
  y = c(610, 650, 625, 690, 660, 610, 655, 700, 590)
)
mound_r <- c(11, 14, 9, 12, 16, 10, 12, 8, 10)
mounds <- st_buffer(st_as_sf(as.data.frame(mound_xy), coords = c("x", "y")), mound_r)
survey <- st_sfc(st_polygon(list(rbind(c(850, 240), c(1160, 280), c(1150, 470), c(860, 440), c(850, 240)))))

# metal-detector finds with attributes
types <- data.frame(
  typ = c("mince", "spona", "přezka", "hrot šípu", "olověná kulka", "nákončí opasku"),
  material = c("stříbro", "bronz", "bronz", "železo", "olovo", "bronz"),
  datace = c("novověk", "doba římská", "středověk", "středověk", "novověk", "raný středověk")
)
n_finds <- 38
finds <- st_sample(survey, n_finds)
finds <- st_sf(
  id = seq_len(n_finds),
  types[sample(nrow(types), n_finds, replace = TRUE, prob = c(4, 2, 2, 1, 4, 1)), ],
  hloubka_cm = round(runif(n_finds, 5, 30)),
  geometry = finds
)
rownames(finds) <- NULL

# helper for a layered vector map
vector_map <- function(vertices = FALSE) {
  vtx <- function(g) st_cast(st_cast(g, "MULTIPOINT"), "POINT")
  p <- ggplot() +
    geom_sf(data = ext_poly, fill = col["pole"], colour = NA) +
    geom_sf(data = forest, aes(fill = "les"), colour = "#4f7f3f") +
    geom_sf(data = survey, aes(fill = "plocha prospekce"), colour = col["prospekce"],
            linetype = "dashed", alpha = 0.15) +
    geom_sf(data = village, aes(fill = "intravilán vsi"), colour = "#9c5a4c", alpha = 0.6) +
    geom_sf(data = houses, fill = "#8b3a2b", colour = NA) +
    geom_sf(data = river, aes(colour = "řeka"), linewidth = 2.2) +
    geom_sf(data = road, aes(colour = "cesta"), linewidth = 1.1) +
    geom_sf(data = road_side, aes(colour = "cesta"), linewidth = 1.1) +
    geom_sf(data = mounds, aes(fill = "mohyly"), colour = "#5a2d0c") +
    geom_sf(data = finds, aes(shape = "nálezy (detektor)"), colour = col["nalez"], size = 1.8) +
    scale_fill_manual(NULL, values = c(les = unname(col["les"]), "plocha prospekce" = unname(col["prospekce"]),
                                       "intravilán vsi" = unname(col["ves"]), mohyly = unname(col["mohyla"]))) +
    scale_colour_manual(NULL, values = c("řeka" = unname(col["reka"]), cesta = unname(col["cesta"]))) +
    scale_shape_manual(NULL, values = 16) +
    coord_sf(xlim = c(0, W), ylim = c(0, H), expand = FALSE, datum = NA)
  if (vertices) {
    p <- p +
      geom_sf(data = vtx(st_simplify(c(road, road_side), dTolerance = 1)), size = 1.8, colour = "black") +
      geom_sf(data = vtx(st_simplify(forest, dTolerance = 8)), size = 1.4, colour = "#2d4f22")
  }
  p
}

# DEM (2 m) with valley and barrows
r <- rast(xmin = 0, xmax = W, ymin = 0, ymax = H, resolution = 2)
xy <- crds(r)
z <- 230 + 0.025 * xy[, 2] +
  14 * exp(-((xy[, 1] - 1000)^2 + (xy[, 2] - 640)^2) / (2 * 220^2)) -
  7 * exp(-(xy[, 2] - river_y(xy[, 1]))^2 / (2 * 70^2))
for (i in seq_len(nrow(mound_xy))) {
  d2 <- (xy[, 1] - mound_xy[i, 1])^2 + (xy[, 2] - mound_xy[i, 2])^2
  z <- z + 2 * (mound_r[i] / 12) * exp(-d2 / (2 * (mound_r[i] / 2)^2))
}
values(r) <- z
names(r) <- "dmr"
hs <- shade(terrain(r, "slope", unit = "radians"), terrain(r, "aspect", unit = "radians"), angle = 40, direction = 315)

# land-cover raster
landcover <- function(res) {
  lc <- rast(xmin = 0, xmax = W, ymin = 0, ymax = H, resolution = res)
  v <- rbind(
    st_sf(k = 2, geometry = forest),
    st_sf(k = 3, geometry = village),
    st_sf(k = 5, geometry = st_union(c(st_buffer(road, 4), st_buffer(road_side, 4)))),
    st_sf(k = 4, geometry = st_buffer(river, 9)),
    st_sf(k = 6, geometry = st_union(mounds))
  )
  out <- rasterize(vect(v), lc, field = "k", touches = TRUE, fun = "max")
  out <- ifel(is.na(out), 1, out)
  levels(out) <- data.frame(id = 1:6, kategorie = c("pole", "les", "ves", "řeka", "cesta", "mohyly"))
  out
}
lc_cols <- c(pole = unname(col["pole"]), les = unname(col["les"]), ves = unname(col["ves"]),
             "řeka" = unname(col["reka"]), cesta = unname(col["cesta"]), mohyly = unname(col["mohyla"]))

raster_map <- function(lc, grid = TRUE) {
  d <- as.data.frame(lc, xy = TRUE)
  p <- ggplot(d, aes(x, y, fill = kategorie)) +
    geom_raster() +
    scale_fill_manual(NULL, values = lc_cols, drop = FALSE) +
    coord_sf(xlim = c(0, W), ylim = c(0, H), expand = FALSE, datum = NA)
  if (grid) {
    rs <- res(lc)[1]
    p <- p +
      geom_vline(xintercept = seq(0, W, rs), colour = "white", linewidth = 0.15, alpha = 0.6) +
      geom_hline(yintercept = seq(0, H, rs), colour = "white", linewidth = 0.15, alpha = 0.6)
  }
  p
}

# vector vs raster, side by side
p_vr <- (vector_map() + ggtitle("Vektor") + theme(legend.position = "none")) +
  (raster_map(landcover(25)) + ggtitle("Rastr (buňka 25 m)") + theme(legend.position = "none")) &
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))
save_fig(p_vr, "landscape-vector-raster.png", h = 4.2)

# full vector map with legend
save_fig(vector_map() + theme(legend.position = "right"), "landscape-vector.png")

# continuous raster: DEM + hillshade, with a zoom on the barrow cemetery
dem_df <- as.data.frame(c(r, hs), xy = TRUE)
names(dem_df)[4] <- "hs"
p_dem <- ggplot(dem_df, aes(x, y)) +
  geom_raster(aes(fill = dmr)) +
  geom_raster(aes(alpha = 1 - hs), fill = "black", show.legend = FALSE) +
  scale_alpha(range = c(0, 0.55)) +
  scale_fill_gradientn("nadm. výška\n(m n. m.)", colours = c("#2c7bb6", "#a6d96a", "#ffffbf", "#fdae61", "#a0522d")) +
  annotate("rect", xmin = 870, xmax = 1150, ymin = 560, ymax = 740, fill = NA, colour = "black", linewidth = 0.8) +
  coord_sf(xlim = c(0, W), ylim = c(0, H), expand = FALSE, datum = NA) +
  ggtitle("Digitální model reliéfu (buňka 2 m)") +
  theme(legend.position = "bottom", legend.key.width = unit(1.5, "cm"))

zoom <- crop(r, ext(1040, 1060, 650, 670))
zoom_df <- as.data.frame(zoom, xy = TRUE)
p_zoom <- ggplot(zoom_df, aes(x, y)) +
  geom_tile(aes(fill = dmr), colour = "white", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%.1f", dmr)), size = 3.2) +
  scale_fill_gradientn(colours = c("#ffffbf", "#fdae61", "#a0522d"), guide = "none") +
  coord_equal(expand = FALSE) +
  ggtitle("Detail mohyly: buňka = číslo")
save_fig((p_dem | p_zoom) + plot_layout(widths = c(1.6, 1)) &
           theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 15)),
         "landscape-dem.png")

# resolution: the same village at three cell sizes
res_panel <- function(res) {
  lc <- landcover(res)
  raster_map(crop(lc, ext(480, 840, 240, 600)), grid = res >= 5) +
    geom_sf(data = village, fill = NA, colour = "black", linewidth = 0.6, inherit.aes = FALSE) +
    coord_sf(xlim = c(480, 840), ylim = c(240, 600), expand = FALSE, datum = NA) +
    ggtitle(paste0("buňka ", res, " m")) +
    theme(legend.position = "none", plot.title = element_text(hjust = 0.5, face = "bold"))
}
save_fig(res_panel(40) | res_panel(15) | res_panel(3), "resolution.png", h = 4)

# geometry types
gt_theme <- theme(legend.position = "none", plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
                  plot.subtitle = element_text(hjust = 0.5, size = 13))
base <- ggplot() + geom_sf(data = ext_poly, fill = "grey97", colour = "grey80") +
  coord_sf(xlim = c(0, W), ylim = c(0, H), expand = FALSE, datum = NA)
pts <- function(g, tol) st_cast(st_cast(st_simplify(g, dTolerance = tol), "MULTIPOINT"), "POINT")
p_pt <- base + geom_sf(data = finds, colour = col["nalez"], size = 2.4) +
  labs(title = "Body (point)", subtitle = "nálezy, sondy, vzorky")
p_ln <- base +
  geom_sf(data = st_simplify(river, dTolerance = 6), colour = col["reka"], linewidth = 1.4) +
  geom_sf(data = c(road, road_side), colour = col["cesta"], linewidth = 1.1) +
  geom_sf(data = pts(river, 6), size = 1.3) +
  geom_sf(data = pts(c(road, road_side), 1), size = 1.8) +
  labs(title = "Linie (line)", subtitle = "cesty, toky, řezy, profily")
p_pl <- base +
  geom_sf(data = st_simplify(forest, dTolerance = 8), fill = col["les"], colour = "#4f7f3f") +
  geom_sf(data = village, fill = col["ves"], colour = "#9c5a4c") +
  geom_sf(data = mounds, fill = col["mohyla"], colour = "#5a2d0c") +
  geom_sf(data = pts(forest, 8), size = 1.3) +
  geom_sf(data = pts(village, 0), size = 1.1) +
  labs(title = "Polygony (polygon)", subtitle = "sondy, objekty, mohyly, les")
save_fig((p_pt | p_ln | p_pl) & gt_theme, "geometry-types.png", h = 3.5)

# attribute table linked to the map
sel <- 7
tab <- st_drop_geometry(finds)[1:10, c("id", "typ", "material", "datace", "hloubka_cm")]
names(tab)[c(3, 5)] <- c("materiál", "hloubka (cm)")
fills <- ifelse(tab$id == sel, "#fdd49e", rep(c("grey95", "grey88"), length.out = nrow(tab)))
tg <- gridExtra::tableGrob(tab, rows = NULL, theme = gridExtra::ttheme_default(
  base_size = 12, core = list(bg_params = list(fill = fills)),
  colhead = list(bg_params = list(fill = "#3c6e91"), fg_params = list(col = "white"))
))
p_attr_map <- ggplot() +
  geom_sf(data = survey, fill = "grey97", colour = col["prospekce"], linetype = "dashed") +
  geom_sf(data = finds, colour = col["nalez"], size = 2.5) +
  geom_sf(data = finds[sel, ], shape = 21, size = 8, stroke = 1.6, colour = "black", fill = NA) +
  geom_sf_text(data = finds[1:10, ], aes(label = id), nudge_x = 9, nudge_y = 7, size = 4.5, colour = "grey20") +
  coord_sf(datum = NA)
save_fig(p_attr_map + wrap_elements(tg) + plot_layout(widths = c(1, 1.1)), "attributes.png", h = 4.2)

# Formats: shapefile vs geopackage ----------------------------------------

card <- function(x, y, w, h, fill, label, sub = NULL) {
  l <- list(
    annotate("rect", xmin = x, xmax = x + w, ymin = y, ymax = y + h, fill = fill, colour = "grey30"),
    annotate("text", x = x + 0.15, y = y + h / 2, label = label, hjust = 0, size = 6, fontface = "bold")
  )
  if (!is.null(sub)) l <- c(l, annotate("text", x = x + w - 0.15, y = y + h / 2, label = sub, hjust = 1, size = 5, colour = "grey25"))
  l
}
shp <- data.frame(
  f = paste0("nalezy", c(".shp", ".shx", ".dbf", ".prj", ".cpg")),
  s = c("geometrie", "index geometrie", "atributy (tabulka)", "souř. systém (CRS)", "kódování znaků"),
  fill = c("#cfe2f3", "#cfe2f3", "#d9ead3", "#fff2cc", "#f4cccc")
)
gp <- data.frame(
  f = c("nalezy", "mohyly", "cesty", "les", "dmr"),
  s = c("body", "polygony", "linie", "polygony", "rastr")
)
p_fmt <- ggplot() +
  xlim(0, 13) + ylim(-0.6, 6.6) +
  annotate("text", x = 0, y = 6.3, label = "Shapefile = 4–6 souborů", hjust = 0, size = 7, fontface = "bold") +
  lapply(1:5, \(i) card(0, 5.3 - i * 1.05, 5.6, 0.85, shp$fill[i], shp$f[i], shp$s[i])) +
  annotate("text", x = 0, y = -0.35, label = "1 vrstva, chybí-li soubor, data jsou poškozená", hjust = 0, size = 5, colour = "#b45f06") +
  annotate("text", x = 7, y = 6.3, label = "GeoPackage = 1 soubor", hjust = 0, size = 7, fontface = "bold") +
  annotate("rect", xmin = 7, xmax = 13, ymin = -0.05, ymax = 5.6, fill = "#eef5ea", colour = "grey30", linewidth = 1) +
  annotate("text", x = 7.2, y = 5.25, label = "vyzkum_2026.gpkg", hjust = 0, size = 6.5, fontface = "bold") +
  lapply(1:5, \(i) card(7.3, 4.85 - i * 0.95, 5.4, 0.78, "white", gp$f[i], gp$s[i])) +
  annotate("text", x = 7, y = -0.35, label = "víc vrstev (i rastry) v jednom souboru", hjust = 0, size = 5, colour = "#38761d")
save_fig(p_fmt, "formats.png")

# CRS ---------------------------------------------------------------------

venue <- st_sfc(st_point(c(16.62125, 49.18913)), crs = 4326) # ARÚB, Čechyňská 363/19, Brno (OSM)
cz <- gisco_get_countries(country = "CZ", resolution = "03")

crs_panel <- function(crs, title) {
  ggplot() +
    geom_sf(data = cz, fill = "grey88", colour = "grey30") +
    geom_sf(data = venue, colour = col["nalez"], size = 3) +
    coord_sf(crs = crs, datum = 4326) +
    ggtitle(title) +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 14), axis.text = element_text(size = 9))
}
p_crs <- crs_panel(4326, "WGS 84\nEPSG:4326") |
  crs_panel(3857, "WGS 84 / Pseudo-Mercator\nEPSG:3857") |
  crs_panel(5514, "S-JTSK / Křovák East North\nEPSG:5514")
save_fig(p_crs, "czechia-crs.png", h = 3.6)

# swapped coordinates (lat/lon order)
world <- gisco_get_countries(resolution = "20")
swapped <- st_sfc(st_point(c(49.18913, 16.62125)), crs = 4326)
null_island <- st_sfc(st_point(c(0, 0)), crs = 4326)
lab <- function(g, text, colour, nx, ny) {
  annotate("label", x = st_coordinates(g)[1] + nx, y = st_coordinates(g)[2] + ny, label = text,
           colour = colour, size = 5, linewidth = 0, fill = "white", alpha = 0.85)
}
p_swap <- ggplot() +
  geom_sf(data = world, fill = "grey90", colour = "grey60", linewidth = 0.2) +
  geom_sf(data = venue, colour = "#38761d", size = 4) +
  geom_sf(data = swapped, colour = col["nalez"], size = 4) +
  geom_sf(data = null_island, colour = "#0b5394", size = 4) +
  lab(venue, "49,19° N; 16,62° E\nsprávně: Brno", "#38761d", 0, 8) +
  lab(swapped, "16,62° N; 49,19° E\nprohozené souřadnice: Jemen", col["nalez"], -6, -8) +
  lab(null_island, "0°; 0°\nchybějící / nulové souřadnice", "#0b5394", 6, -8) +
  coord_sf(xlim = c(-30, 75), ylim = c(-12, 62), expand = FALSE, datum = NA) +
  theme(panel.background = element_rect(fill = "#e8f1f8", colour = NA))
save_fig(p_swap, "crs-mistakes.png")

# venue coordinates for the slides
dms <- function(v, pos, neg) {
  d <- floor(abs(v)); m <- (abs(v) - d) * 60; s <- (m - floor(m)) * 60
  sprintf("%s %d° %d′ %.1f″", ifelse(v >= 0, pos, neg), d, floor(m), s)
}
ll <- st_coordinates(venue)
cat("WGS 84 decimal:", sprintf("%.5f N, %.5f E", ll[2], ll[1]), "\n")
cat("WGS 84 DMS:", dms(ll[2], "N", "S"), dms(ll[1], "E", "W"), "\n")
cat("S-JTSK 5514:", sprintf("%.1f", st_coordinates(st_transform(venue, 5514))), "\n")
cat("UTM 33N 32633:", sprintf("%.1f", st_coordinates(st_transform(venue, 32633))), "\n")
