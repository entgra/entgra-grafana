# ------------------------------------------------------------------------
#
# Copyright (C) 2018 - 2025 Entgra (Pvt) Ltd, Inc - All Rights Reserved.
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

# Replace the Cannot visualize data to Loading 

USER root

# Copy custom assets to a temporary location inside the container
COPY ./images/logo.svg /tmp/logo.svg
COPY ./images/logo-cropped.png /tmp/fav32.png

# Replace "Cannot visualize data" and "Welcome to Grafana"
RUN sed -i 's/Cannot visualize data/Loading...           /g' /usr/share/grafana/public/locales/en-US/grafana.json && \
    sed -i 's/Welcome to Grafana/Welcome to Analytics/g' /usr/share/grafana/public/locales/en-US/grafana.json

# Replace "Grafana" with "Entgra" for general UI elements (like the Login Page)
RUN sed -i 's/"Grafana"/"Entgra"/g' /usr/share/grafana/public/locales/en-US/grafana.json

# Find every instance of the Grafana icon (including hashed ones like grafana_icon.1e0deb6b.svg) and overwrite it
RUN find /usr/share/grafana/public -type f -name "grafana_icon*.svg" -exec cp /tmp/logo.svg {} \;

# Overwrite all favicons and apple-touch icons
RUN find /usr/share/grafana/public -type f -name "fav32.png" -exec cp /tmp/fav32.png {} \; && \
    find /usr/share/grafana/public -type f -name "apple-touch-icon.png" -exec cp /tmp/fav32.png {} \;

# Clean up temp files
RUN rm /tmp/logo.svg /tmp/fav32.png