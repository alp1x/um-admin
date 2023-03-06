local version = "1.3.0"
local updateUrl = "https://raw.githubusercontent.com/alp1x/um-admin/main/checker/checkversion" -- URL to check for updates

PerformHttpRequest(updateUrl, function(err, response, headers)
    local latestVersion = response:gsub("%s+", "")
    if latestVersion ~= version then
        print("\27[31m[UM-Admin] new version is available! "..latestVersion.."\27[0m [https://github.com/alp1x/um-admin]")
    end
end)