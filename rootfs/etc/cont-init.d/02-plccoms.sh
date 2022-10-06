#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Base Images
# Configures the timezone
# ==============================================================================

bashio::log.blue "Running PLCComs from init"
cd /opt/plccoms
./PLCComS.sh