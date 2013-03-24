#!/bin/bash
# Helper script to start FinderMenu
xcodebuild clean && \
xcodebuild && \
killall Finder && \
rm -f ~/FinderExt.log && \
sleep 1 && \
sudo build/Release/FinderMenu && \
sleep 1 && \
tail -f ~/FinderExt.log