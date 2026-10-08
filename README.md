# Workshop QGIS

Materiály k workshopu QGIS.

- **15. 10. 2026, 10:00**, velký sál

## Co budete potřebovat

- [ ] Vlastní notebook.
- [ ] Nainstalovaný QGIS (nejlépe verze 3.44.x **v angličtině**)
  <https://qgis.org/download/>.
- [ ] Registraci ve školicí verzi AMČR <https://amcr-tr.aiscr.cz/>.

## Program

1. Úvod a zahájení (Jaké máte zkušenosti s GIS? Co se chcete naučit?)
2. Trochu teorie (vektorová a rastrová data, souřadnicové systémy atd.)
3. Rozhraní QGIS
4. Projekty v QGIS
5. Data a datové zdroje (WMS atd.)
6. Práce s vrstvami
7. Import dat z AMČR
8. Georeferencování
9. Export dat ve formátu AMČR (tvorba PIANů)
10. Export mapy

## Užitečné odkazy a zdroje
- Geoprohlížeč ČÚZK  
  http://ags.cuzk.gov.cz/geoprohlizec
- Geodata pro EU  
  https://inspire-geoportal.ec.europa.eu/srv/eng/catalog.search#/home
- Natural Earth Data  
  https://www.naturalearthdata.com/
- GADM (databáze administrativních celků světa)  
  https://gadm.org/data.html
  
### Zásuvné moduly
- *Instalujte je ve správci zásuvných modulů QGIS (Plugin manager)*
- OSM place search
- Pian Exporter
- AMČR Viewer
- OpenTopography DEM Downloader (vyžaduje bezplatnou registraci na
  https://portal.opentopography.org/)
- XYZ Tiles Basemap Loader

### Prohlížecí služby (WMS)
- ZTM (Základní topografická mapa) 1:5000  
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
- MČR (Mapa České republiky) 1:500000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/MCR500/MapServer/WMSServer
- MČR 1:1000000  
  https://ags.cuzk.gov.cz/arcgis1/services/ZTM/MCR1M/MapServer/WMSServer
- **Ortofoto**  
  https://ags.cuzk.gov.cz/arcgis1/services/ORTOFOTO/MapServer/WMSServer
- Archivní ortofoto  
  https://geoportal.cuzk.gov.cz/WMS_ORTOFOTO_ARCHIV/WMService.aspx?
- Katastrální mapa  
  https://services.cuzk.gov.cz/wms/wms.asp
- Geologická mapa  
  https://mapy.geology.cz/arcgis/services/Geologie/geologicka_mapa50/MapServer/WMSServer
- Oblastní plány rozvoje lesů  
  https://geoportal.nli.gov.cz/wms_oprl/WMService.aspx
- Půdní typy  
  https://mapy.geology.cz/arcgis/services/Pudy/pudni_typy50/MapServer/WmsServer

### Stahovací služby (WFS)
- ZABAGED – polohopis  
  https://ags.cuzk.cz/arcgis/services/ZABAGED_POLOHOPIS/MapServer/WFSServer
- ZABAGED – vrstevnice  
  https://ags.cuzk.cz/arcgis/services/ZABAGED_VRSTEVNICE/MapServer/WFSServer
- **Data50**  
  https://ags.cuzk.gov.cz/arcgis/services/DATA50/MapServer/WFSServer
- Surovinový informační systém (SurIS)  
  https://mapy.geology.cz/arcgis/services/Suroviny/loziska_zdroje/MapServer/WFSServer

### Servery ArcGIS REST
- NPÚ
  - Chráněná území – kulturní dědictví  
  https://geoportal.npu.cz/arcgis/rest/services/INSPIRE/ProtectedSites/MapServer
  - CZ_RETRO  
  https://geoportal.npu.cz/arcgis/rest/services/CZ_RETRO/
  - ÚAN (území s archeologickými nálezy)  
  https://geoportaltest.npu.cz/arcgis/rest/services/ISAD/Uzemi_archeologickeho_nalezu_public/MapServer

## Předchozí verze repozitáře
- [ARÚB interní 02/2026](https://github.com/arubrno/qgis-workshop/tree/arub-interni-02/2026)
