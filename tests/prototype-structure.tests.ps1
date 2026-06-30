$ErrorActionPreference = "Stop"

function Assert-Contains {
  param(
    [string]$Content,
    [string]$Pattern,
    [string]$Message
  )

  if ($Content -notmatch [regex]::Escape($Pattern)) {
    throw $Message
  }
}

function Assert-Matches {
  param(
    [string]$Content,
    [string]$Pattern,
    [string]$Message
  )

  if ($Content -notmatch $Pattern) {
    throw $Message
  }
}

$root = Split-Path -Parent $PSScriptRoot
$composePath = Join-Path $root "prototypes/variant-8-new-compose.html"
$mobilePath = Join-Path $root "prototypes/variant-8-new-mobile.html"

if (!(Test-Path $composePath)) {
  throw "Missing variant-8-new-compose.html"
}

if (!(Test-Path $mobilePath)) {
  throw "Missing variant-8-new-mobile.html"
}

$compose = Get-Content -Raw $composePath
$mobile = Get-Content -Raw $mobilePath

foreach ($name in @("past-image", "destruction-image", "renewal-image")) {
  Assert-Contains $compose "data-name=`"$name`"" "Compose playground is missing image element $name"
  Assert-Contains $mobile "data-name=`"$name`"" "Mobile variant is missing image element $name"
}

foreach ($name in @("past-label", "destruction-label", "renewal-label")) {
  Assert-Contains $compose "data-name=`"$name`"" "Compose playground is missing label element $name"
  Assert-Contains $mobile "data-name=`"$name`"" "Mobile variant is missing label element $name"
}

foreach ($label in @("Great Past", "Destruction", "Renewal")) {
  Assert-Contains $compose $label "Compose playground is missing label text: $label"
  Assert-Contains $mobile $label "Mobile variant is missing label text: $label"
}

foreach ($tool in @("resize-handle", "rotate-handle", "data-action=`"flip-x`"", "data-action=`"flip-y`"", "data-action=`"save`"")) {
  Assert-Contains $compose $tool "Compose playground lost editor control: $tool"
}

Assert-Contains $compose "showDirectoryPicker" "Compose playground lost direct prototypes-folder save support"
Assert-Contains $mobile "@keyframes imageCycle" "Mobile variant is missing imageCycle animation"
Assert-Contains $mobile "@keyframes focusCycle" "Mobile variant is missing focusCycle animation"
Assert-Contains $mobile "@keyframes labelCycle" "Mobile variant is missing labelCycle animation"
Assert-Contains $mobile "animation-delay: 0s" "Mobile variant is missing first sequential animation delay"
Assert-Contains $mobile "animation-delay: 6s" "Mobile variant is missing second sequential animation delay"
Assert-Contains $mobile "animation-delay: 12s" "Mobile variant is missing third sequential animation delay"
Assert-Matches $mobile "0%, 29%, 100%\s*\{\s*opacity: 0;" "Mobile variant should hide each image outside its own animation slot"
Assert-Contains $mobile "prefers-reduced-motion: reduce" "Mobile variant is missing reduced-motion fallback"

Write-Host "Prototype structure tests passed."
