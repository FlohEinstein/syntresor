FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive 

# update the system
RUN apt-get update -y && \
    apt-get upgrade -y

# dependencies
RUN apt-get install -y --no-install-recommends \
	x11vnc \
	net-tools \
	ca-certificates \
	curl \
	python \
	python-numpy \
	python-xdg \
	xvfb \
	openbox \
	menu 

# create the user
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo tresorit
USER tresorit
WORKDIR /home/tresorit

# noVNC
RUN  curl -L https://github.com/novnc/noVNC/archive/master.tar.gz | tar xzv && \
	mv noVNC-master noVNC && \
	rm -r ./noVNC/tests && \
	cd noVNC/utils && \
	curl -L https://github.com/novnc/websockify/archive/master.tar.gz | tar xzv && \
	mv websockify-master websockify && \
	rm -r ./websockify/tests ./websockify/Windows

# tresorit
RUN curl -LO https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run && \
    chmod +x ./tresorit_installer.run && \
	echo "N " | ./tresorit_installer.run --update-v2 . && \
	rm ./tresorit_installer.run

# volumes
RUN mkdir -p /home/tresorit/.config/Tresorit \
			 /home/tresorit/Logs \
			 /home/tresorit/Profiles \
			 /home/tresorit/Reports \
			 /home/tresorit/Temp \
			 /home/tresorit/external

USER root

# cleanup
RUN apt autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
	chmod +777 /tmp

# add the startup script
ADD startup.sh /startup.sh
RUN chmod 0755 /startup.sh

USER tresorit
VOLUME /home/tresorit/.config/Tresorit /home/tresorit/Logs /home/tresorit/Profiles /home/tresorit/Reports /home/tresorit/Temp /home/tresorit/external
EXPOSE 6080
CMD /startup.sh
