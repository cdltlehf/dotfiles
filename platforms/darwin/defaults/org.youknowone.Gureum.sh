#!/bin/sh

set -o nounset
set -o errexit

defaults delete org.youknowone.Gureum 2>/dev/null || true
defaults write org.youknowone.Gureum ExchangeToRomanModeByEscapeKey -bool true
defaults write org.youknowone.Gureum HangulAutoReorder -bool true
defaults write org.youknowone.Gureum HangulForceStrictCombinationRule -bool true
defaults write org.youknowone.Gureum InputModeExchangeKey \
  -dict keyCode -int 49 modifier -int 131072
defaults write org.youknowone.Gureum InputModeHanjaKey -dict
defaults write org.youknowone.Gureum LastHangulInputMode \
  -string "org.youknowone.inputmethod.Gureum.han3finalnoshift"
defaults write org.youknowone.Gureum LastRomanInputMode \
  -string "org.youknowone.inputmethod.Gureum.qwerty"
defaults write org.youknowone.Gureum UpdateNotificationExperimental -bool true
