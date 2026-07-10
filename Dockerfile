# ------------------------------------------------------------------------
#
# Copyright (C) 2018 - 2026 Entgra (Pvt) Ltd, Inc - All Rights Reserved.
#
# Unauthorised copying/redistribution of this file, via any medium is strictly prohibited.
#
# Licensed under the Entgra Commercial License, Version 1.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://entgra.io/licenses/entgra-commercial/1.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# ------------------------------------------------------------------------

FROM grafana/grafana:10.4.0

USER root

# Copy custom assets
COPY ./images/logo.svg /tmp/logo.svg
COPY ./images/logo-cropped.png /tmp/fav32.png

# Update Locale Files
RUN sed -i 's/Cannot visualize data/Loading...           /g' /usr/share/grafana/public/locales/en-US/grafana.json && \
    sed -i 's/Welcome to Grafana/Welcome to Analytics/g' /usr/share/grafana/public/locales/en-US/grafana.json && \
    sed -i 's/"Grafana"/"Entgra"/g' /usr/share/grafana/public/locales/en-US/grafana.json

# Surgical JS String Replacements
RUN find /usr/share/grafana/public/build -type f -name "*.js" -exec sed -i \
    -e 's/Cannot visualize data/Loading...           /g' \
    -e 's/Welcome to Grafana/Welcome to Analytics/g' \
    -e 's/Login to Grafana/Login to Entgra/g' \
    -e 's/>Grafana</>Entgra</g' \
    -e 's/aria-label="Grafana"/aria-label="Entgra"/g' \
    -e 's/title="Grafana"/title="Entgra"/g' {} +

# Update initial HTML properties
RUN sed -i 's/\[\[.AppTitle\]\]/Entgra Analytics/g' /usr/share/grafana/public/views/index.html || true && \
    sed -i 's/<title>Grafana<\/title>/<title>Entgra Analytics<\/title>/g' /usr/share/grafana/public/views/index.html || true

# Inject a Dynamic Tab-Title Script
RUN sed -i 's/<\/body>/<script>const observer = new MutationObserver(() => { if (document.title.includes("Grafana")) { document.title = document.title.replace(\/Grafana\/g, "Entgra"); } }); observer.observe(document.querySelector("head"), { subtree: true, childList: true, characterData: true });<\/script><\/body>/g' /usr/share/grafana/public/views/index.html

# Replace Icons
RUN find /usr/share/grafana/public -type f -name "grafana_icon*.svg" -exec cp /tmp/logo.svg {} \;
RUN find /usr/share/grafana/public -type f -name "fav32.png" -exec cp /tmp/fav32.png {} \; && \
    find /usr/share/grafana/public -type f -name "apple-touch-icon.png" -exec cp /tmp/fav32.png {} \;

# Clean up temp files
RUN rm /tmp/logo.svg /tmp/fav32.png