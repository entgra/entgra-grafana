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

FROM  grafana/grafana-oss:9.5.1

# Replace the Cannot visualize data to Loading 

USER root
RUN sed -i 's/Cannot visualize data/Loading...           /g' /usr/share/grafana/public/build/*.js

#Replace "Loading Grafana" to "Loading"
RUN sed -i 's/Loading Grafana/Loading...           /g' /usr/share/grafana/public/views/*.html

#Replace "Welcome to Grafana" to "Welcome to Analytics"
RUN find /usr/share/grafana/public \
  -type f \( \
    -name "*.js" -o \
  \) -exec sed -i 's/Welcome to Grafana/Welcome to Analytics/g' {} +

#Replace "Grafana" to "Entgra" in Login Page
RUN find /usr/share/grafana/public/build \
  -type f \( \
    -name "*.js" -o \
  \) -exec sed -i 's/Grafana/Entgra/g' {} +

#Change favicon and grafana icon
COPY ./images/logo.svg /usr/share/grafana/public/img/grafana_icon.svg
COPY ./images/logo-cropped.png /usr/share/grafana/public/img/fav32.png
COPY ./images/logo-cropped.png /usr/share/grafana/public/img/apple-touch-icon.png
