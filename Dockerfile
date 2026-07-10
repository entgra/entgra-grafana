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

FROM grafana/grafana:13.1.0

USER root

# Copy custom assets to a temporary location inside the container
COPY ./images/logo.svg /tmp/logo.svg
COPY ./images/logo-cropped.png /tmp/fav32.png

# Update the Default Home Dashboard
RUN if [ -f /usr/share/grafana/public/dashboards/home.json ]; then \
        sed -i 's/Welcome to Grafana/Welcome to Analytics/g' /usr/share/grafana/public/dashboards/home.json; \
    fi

# Update Locale Files
RUN if [ -d /usr/share/grafana/public/locales ]; then \
        find /usr/share/grafana/public/locales -type f -name "*.json" -exec sed -i \
        -e 's/Cannot visualize data/Loading...           /g' \
        -e 's/Welcome to Grafana/Welcome to Analytics/g' \
        -e 's/"Grafana"/"Entgra"/g' {} + ; \
    fi

# Update Compiled JS Bundles
RUN find /usr/share/grafana/public/build -type f -name "*.js" -exec sed -i \
    -e 's/Cannot visualize data/Loading...           /g' \
    -e 's/Welcome to Grafana/Welcome to Analytics/g' \
    -e 's/Login to Grafana/Login to Entgra/g' \
    -e 's/" - Grafana"/" - Entgra"/g' \
    -e "s/' - Grafana'/' - Entgra'/g" \
    -e 's/` - Grafana`/` - Entgra`/g' \
    -e 's/ - Grafana/ - Entgra/g' \
    -e 's/Grafana - /Entgra - /g' \
    -e 's/>Grafana</>Entgra</g' \
    -e 's/"Grafana"/"Entgra"/g' \
    -e "s/'Grafana'/'Entgra'/g" {} +

# Update HTML Template & BootData
RUN sed -i 's/\[\[.AppTitle\]\]/Entgra Analytics/g' /usr/share/grafana/public/views/index.html || true && \
    sed -i 's/"appTitle":"Grafana"/"appTitle":"Entgra Analytics"/g' /usr/share/grafana/public/views/index.html || true && \
    sed -i 's/<title>Grafana<\/title>/<title>Entgra Analytics<\/title>/g' /usr/share/grafana/public/views/index.html || true

# Replace Icons
RUN find /usr/share/grafana/public -type f -name "grafana_icon*.svg" -exec cp /tmp/logo.svg {} \;

# Overwrite all favicons and apple-touch icons
RUN find /usr/share/grafana/public -type f -name "fav32.png" -exec cp /tmp/fav32.png {} \; && \
    find /usr/share/grafana/public -type f -name "apple-touch-icon.png" -exec cp /tmp/fav32.png {} \;

# Clean up temp files
RUN rm /tmp/logo.svg /tmp/fav32.png