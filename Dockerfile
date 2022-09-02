# Inspire by fischerscode/flutter
# Work only for ARM64/v8 architecture (Macbook M1)

FROM --platform=linux/arm64/v8 ubuntu:22.04

RUN apt-get update && \
    apt-get install -y bash wget curl file git openjdk-11-jdk unzip xz-utils zip libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

# General variables
ARG FLUTTER_VERSION=3.0.0
ARG ANDROID_API_LEVEL_1st=31
ARG ANDROID_API_LEVEL_2nd=30
ARG ANDROID_BUILD_TOOLS_LEVEL=33.0.0
# How to know the number to download: Android Studio -> Click download any Android SDk Commnand-line -> Hit Apply
# It will show the link where the package is downloaded
# ANNDROID_CMD_LINE_TOOLS version 7.0
ARG ANNDROID_CMD_LINE_TOOLS=linux-8512546_latest
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME=user
# Define user

# Use the -m (--create-home) option to create the user home directory as /home/${USER_NAME}:
# Use the -r (--system) option to create a system user account. System users are created with no expiry date.
RUN useradd --no-log-init -rm -d /home/${USER_NAME} -g root -G sudo -u 1001 ${USER_NAME}
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# Download commandlinetools
RUN mkdir -p android/cmdline-tools
RUN mkdir .android && touch .android/repositories.cfg
RUN wget -q https://dl.google.com/android/repository/commandlinetools-${ANNDROID_CMD_LINE_TOOLS}.zip -P /tmp
RUN unzip -q -d android/cmdline-tools /tmp/commandlinetools-${ANNDROID_CMD_LINE_TOOLS}.zip

# Install packages and accept all licenses
RUN yes Y | android/cmdline-tools/cmdline-tools/bin/sdkmanager --install "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" "platforms;android-${ANDROID_API_LEVEL_1st}" "platforms;android-${ANDROID_API_LEVEL_2nd}" --verbose \
&& yes Y | android/cmdline-tools/cmdline-tools/bin/sdkmanager --licenses

# Install flutter
RUN git clone https://github.com/flutter/flutter.git --branch ${FLUTTER_VERSION} flutter
# precache: Downloading Linux arm64 Dart SDK from Flutter engine
RUN flutter/bin/flutter precache
RUN flutter/bin/flutter config --no-analytics

# Setup ENV
ENV ANDROID_HOME=/home/${USER_NAME}/android
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
ENV PATH="$PATH:/home/${USER_NAME}/flutter/bin"
ENV PATH="$PATH:/home/${USER_NAME}/flutter/bin/cache/dart-sdk/bin"
ENV PATH="$PATH:$ANDROID_HOMEcmdline-tools/cmdline-tools/bin"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"
ENV PATH="$PATH:$JAVA_HOME"

# # Have to create a directory, otherwise COPY to a destination won't work
# RUN mkdir test_buildtool33
# COPY --chown=${USER_NAME} /test_buildtool33 test_buildtool33

# # WORKDIR  /home/${USER_NAME}/test_buildtool33
# # RUN flutter build apk --release --verbose

# Clean up
WORKDIR /
RUN rm -r /tmp/commandlinetools-${ANNDROID_CMD_LINE_TOOLS}.zip


# WORKDIR  /home/${USER_NAME}/test_buildtool33
