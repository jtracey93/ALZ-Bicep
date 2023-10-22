$githubRepoUrl = "https://github.com/Azure/Enterprise-Scale"

# Split Repo URL into parts
$repoOrgPlusRepo = $githubRepoUrl.Split("/")[-2..-1] -join "/"

$repoReleasesUrl = "https://api.github.com/repos/$repoOrgPlusRepo/releases"
$allRepoReleases = Invoke-RestMethod $repoReleasesUrl

Write-Host ""
Write-Host "=====> Checking for releases on GitHub Repo: $repoOrgPlusRepo" -ForegroundColor Cyan
Write-Host ""
Write-Host "=====> All available releases on GitHub Repo: $repoOrgPlusRepo" -ForegroundColor Cyan
$allRepoReleases | Select-Object name, tag_name, published_at, prerelease, draft, html_url | Format-Table -AutoSize

# Get latest release on repo
$latestRepoRelease = $allRepoReleases | Where-Object { $_.prerelease -eq $false } | Where-Object { $_.draft -eq $false } | Sort-Object -Descending published_at | Select-Object -First 1

Write-Host ""
Write-Host "=====> Latest available release on GitHub Repo: $repoOrgPlusRepo" -ForegroundColor Cyan
$latestRepoRelease | Select-Object name, tag_name, published_at, prerelease, draft, html_url | Format-Table -AutoSize

$latestRepoReleaseVersion = $latestRepoRelease.name

$eslzArmLatestVersion = "https://raw.githubusercontent.com/Azure/Enterprise-Scale/$($latestRepoReleaseVersion)/eslzArm/eslzArm.json"

$eslzArmLatestVersionContent = Invoke-RestMethod $eslzArmLatestVersion

$ambaLatestReleaseUsedByPortalRawUri = $eslzArmLatestVersionContent.variables.rootUris.monitorRepo

$ambaLatestReleaseUsedByPortalVersion = $ambaLatestReleaseUsedByPortalRawUri.Split("/")[5]
