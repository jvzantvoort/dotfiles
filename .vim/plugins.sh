#!/bin/bash
#===============================================================================
#
#         FILE:  plugins.sh
#
#        USAGE:  plugins.sh
#
#  DESCRIPTION:  Crude way to install plugins in vim
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  jvzantvoort (John van Zantvoort), john@vanzantvoort.org
#      COMPANY:  JDC
#      CREATED:  2025-08-05
#
# Copyright (C) 2025 John van Zantvoort
#
#===============================================================================

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

if [[ ! -d "${HOME}/.vim/pack/experiments/start/Ultisnips" ]]
then
  mkdir -p ~/.vim/pack/experiments/start/Ultisnips
  git clone https://github.com/SirVer/ultisnips.git ~/.vim/pack/experiments/start/Ultisnips
fi

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
