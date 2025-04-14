# Seven Mile Lake Web Map

This is a web-based interactive map for the Seven Mile Lake project, exported from QGIS to Leaflet.

## Project Structure

```
seven-mile-lake/
├── css/           # Stylesheets for the web map
├── data/          # GeoJSON and other data files
├── js/            # JavaScript files for map functionality
├── legend/        # Map legend assets
├── webfonts/      # Web fonts used in the project
├── images/        # General images and icons
├── markers/       # Custom map markers
└── index.html     # Main web page
```

## Features

- Interactive web map built with Leaflet
- Responsive design for desktop and mobile devices
- Custom markers and styling
- Interactive legend
- GeoJSON data layers

## Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/seven-mile-lake.git
   ```

2. Open `index.html` in a web browser to view the map.

## Development

This project was created by exporting a QGIS project to a web map using the [`qgis2Web`](https://github.com/qgis2web/qgis2web) plugin. The main components are:

- Leaflet.js for map rendering
- Custom CSS for styling
- GeoJSON data layers
- JavaScript for map interactions
