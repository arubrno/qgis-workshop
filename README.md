# QGIS Workshop

Materials for a QGIS workshop.

- **17. 2. 2026, 10am** large hall
- The workshop will be held in Czech, with English interpretation available.

## What you'll need

- [ ] Bring your own laptop.
- [ ] Install QGIS (version 3.4 and above; **preferably in English**) <https://qgis.org/download/>.
- [ ] Register in the AMCR training version <https://amcr-tr.aiscr.cz/>.

## Programme 

1. Intro & opening (What is your experience with GIS? What do you expect to learn?)
3. A bit of theory (vector and raster data, CRS etc.)
4. QGIS interface
5. Projects in QGIS
6. Data and datasources (WMS etc.)
7. Working with layers
8. Georeferencing
9. Importing data from AMCR
10. Exporting data in AMCR format (creating PIANs)
11. Export of a map

## Useful links & resources
- Geoviewer ČÚZK  
  http://ags.cuzk.gov.cz/geoprohlizec
- Geodata for EU  
  https://inspire-geoportal.ec.europa.eu/srv/eng/catalog.search#/home
- Natural Earth Data  
  https://www.naturalearthdata.com/
- GADM (Database of Global Administrative Areas)  
  https://gadm.org/data.html
  
### Plugins
- *Install them in the QGIS Plugin manager*
- OSM place search
- Pian Exporter
- OpenTopography DEM Downloader (requires a free registration at https://portal.opentopography.org/)
- XYZ Tiles Basemap Loader

### View services (WMS)
- ZTM (Base Topographic Map) 1:5000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/ZTM5/MapServer/WMSServer
- **ZTM 1:10000**  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/ZTM10/MapServer/WMSServer
- ZTM 1:25000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/ZTM25/MapServer/WMSServer
- ZTM 1:50000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/ZTM50/MapServer/WMSServer
- ZTM 1:100000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/ZTM100/MapServer/WMSServer
- ZTM 1:250000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/ZTM250/MapServer/WMSServer
- MČR (Map of the Czech Republic) 1:500000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/MCR500/MapServer/WMSServer
- MČR 1:1000000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/MCR1M/MapServer/WMSServer
- **Ortophoto**  
  https://ags.cuzk.gov.cz/arcgis1/services/ORTOFOTO/MapServer/WMSServer
- Archival ortophoto  
  https://geoportal.cuzk.gov.cz/WMS_ORTOFOTO_ARCHIV/WMService.aspx
- Cadastral map  
  https://services.cuzk.gov.cz/wms/wms.asp
- Geological map  
  https://mapy.geology.cz/arcgis/services/Geologie/geologicka_mapa50/MapServer/WMSServer
- Oblastní plány rozvoje lesů (forest development plans)  
  https://geoportal.uhul.cz/wms_oprl/WMService.aspx
- Soil types  
  https://mapy.geology.cz/arcgis/services/Pudy/pudni_typy50/MapServer/WmsServer
- Mineral information system (SurIS)  
  https://mapy.geology.cz/arcgis/services/Suroviny/loziska_zdroje/MapServer/WFSServer

### Download services (WFS)
- Zabaged – planimetric components  
  https://ags.cuzk.cz/arcgis/services/ZABAGED_POLOHOPIS/MapServer/WFSServer
- Zabaged – contours  
  https://ags.cuzk.cz/arcgis/services/ZABAGED_VRSTEVNICE/MapServer/WFSServer
- **Data250**  
  https://ags.cuzk.gov.cz/arcgis/services/DATA250/MapServer/WFSServer

### ArcGIS REST Servers
- Moravské křižovatky
  - Stabilní katastr (Franziszeischer Kataster)  
  https://arcgis.cdv.cz/arcgisserver/rest/services/Stabilni_katastr/Stabilni_katastr_I/MapServer  
  https://arcgis.cdv.cz/arcgisserver/rest/services/Stabilni_katastr/Stabilni_katastr_II/MapServer
  - Živé mapy lidar  
  https://arcgis.cdv.cz/arcgisserver/rest/services/zive_mapy/stin045/MapServer (this angle is no longer active)
  https://arcgis.cdv.cz/arcgisserver/rest/services/zive_mapy/stin135/MapServer  
  https://arcgis.cdv.cz/arcgisserver/rest/services/zive_mapy/stin225/MapServer  
  https://arcgis.cdv.cz/arcgisserver/rest/services/zive_mapy/stin315/MapServer
- NPÚ
  - Protected sites - cultural heritage  
  https://geoportal.npu.cz/arcgis/rest/services/INSPIRE/ProtectedSites/MapServer
  - CZ_RETRO  
  https://geoportal.npu.cz/arcgis/rest/services/CZ_RETRO/
  - ÚAN (Territories with archaeological findings)  
  https://geoportal.npu.cz/arcgis/rest/services/Tematicke/CP_UAN/MapServer
