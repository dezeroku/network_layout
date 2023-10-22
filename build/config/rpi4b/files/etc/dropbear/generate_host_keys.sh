#!/bin/sh

dropbearkey -t rsa -s 4096 -f dropbear_rsa_host_key
dropbearkey -t ed25519 -f dropbear_ed25519_host_key
