Diagrams

This folder contains Mermaid diagrams for the database and SPA map.

Files:
- `db.mmd` - ER diagram of the main tables.
- `spa.mmd` - Flowchart of the SPA routes and flows.

To generate PNG/SVG images you can use the Mermaid CLI (mmdc):

1) Install (once):
   npm i -D @mermaid-js/mermaid-cli

2) Generate PNG/SVG:
   npx mmdc -i docs/diagrams/db.mmd -o docs/diagrams/db.png
   npx mmdc -i docs/diagrams/spa.mmd -o docs/diagrams/spa.png

If you don't want to install, you can use the online Mermaid Live Editor to paste the `.mmd` contents and export images.