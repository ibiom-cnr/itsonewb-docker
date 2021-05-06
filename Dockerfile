# Galaxy - ITSoneWB

FROM bgruening/galaxy-stable:20.09

MAINTAINER ma.tangaro@ibiom.cnr.it

COPY . /opt/itsonewb_custom

ENV ITSONEWB_DIR=/opt/itsonewb \
ITSONEWB_CUSTOM=/opt/itsonewb_custom

# Clone ITSoneWB code
RUN git clone https://github.com/ibiom-cnr/itsonewb.git $ITSONEWB_DIR

# Add custom galaxy.yml
ADD galaxy.yml $GALAXY_CONFIG_DIR/galaxy.yml

# Galaxy custom environment variables
# Change brand, homepage style and tool_conf file
ENV GALAXY_CONFIG_BRAND="ITSONEWB" \
GALAXY_CONFIG_WELCOME_URL=$GALAXY_CONFIG_DIR/web/welcome.html \
GALAXY_CONFIG_TOOL_CONFIG_FILE=$GALAXY_CONFIG_DIR/tool_conf.xml

# ITSoneWB tools configuration
ADD tool_conf.xml $GALAXY_CONFIG_DIR/tool_conf.xml
ADD tool_data_table_conf.xml $GALAXY_CONFIG_DIR/tool_data_table_conf.xml

# Container Style
ADD welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
RUN mkdir -p $GALAXY_CONFIG_DIR/web/style
RUN cp $GALAXY_ROOT/static/style/base.css $GALAXY_CONFIG_DIR/web/style/base.css

# Install and Configure ITSoneWB Connector
# Nothing to do

# Install BioMaS
RUN apt-get -qq update && apt-get install -y virtualenv gcc python-dev libfontconfig xvfb libtbb-dev && \
    virtualenv /opt/build_biomas_venv && \
    . /opt/build_biomas_venv/bin/activate && \
    pip install cython && \
    cd $ITSONEWB_DIR/biomas_2_wrapper && \
    python setup.py build_ext --inplace

# Configure CVMFS
ADD data.elixir-italy-cvmfs.conf /etc/cvmfs/config.d/data.elixir-italy-cvmfs.conf
ADD default.local /etc/cvmfs/default.local
ADD data.elixir-italy-cvmfs.pub /etc/cvmfs/keys/data.elixir-italy-cvmfs.pub

# Expose port 80, 443 (webserver), 21 (FTP server), 8800 (Proxy), 9002 (supvisord web app)
EXPOSE :21
EXPOSE :80
EXPOSE :443
EXPOSE :8800
EXPOSE :9002

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
