local _M = { _VERSION = "0.0.1" }

local mstr = require('mystring')
--local utf8 = require('utf8')


local Windows      = "Windows"
local WindowsPhone = "Windows Phone"
local Android      = "Android"
local MacOS        = "macOS"
local IOS          = "iOS"
local Linux        = "Linux"
local ChromeOS     = "ChromeOS"

local Opera            = "Opera"
local OperaMini        = "Opera Mini"
local OperaTouch       = "Opera Touch"
local Chrome           = "Chrome"
local HeadlessChrome   = "Headless Chrome"
local Firefox          = "Firefox"
local InternetExplorer = "Internet Explorer"
local Safari           = "Safari"
local Edge             = "Edge"
local Vivaldi          = "Vivaldi"

local GoogleAdsBot        = "Google Ads Bot"
local Googlebot           = "Googlebot"
local Applebot            = "Applebot"
local Bingbot             = "Bingbot"

local FacebookApp  = "Facebook App"
local InstagramApp = "Instagram App"
local TiktokApp    = "TikTok App"
local Twitterbot          = "Twitterbot"
local FacebookExternalHit = "facebookexternalhit"

-- structure of UserAgent
--
--VersionNo   {Major int, Minor int, Patch int}
--OSVersionNo {Major int, Minor int, Patch int}
--URL         string
--String      string
--Name        string
--Version     string
--OS          string
--OSVersion   string
--Device      string
--Mobile      bool
--Tablet      bool
--Desktop     bool
--Bot         bool

function _M.getUserAgentName(userAgent)
    local ua = _M.parse(userAgent)
    return ua.Name
end

function _M.parse(userAgent)
    local ua = {}
    ua.Bot = false
    ua.Tablet = false
    local tokens = _M.parseUserAgent(userAgent)
    for k, v in pairs(tokens) do
        if mstr.startswith(k, "http://") or mstr.startswith(k, "https://") then
            tokens[k] = nil
        end
    end

    if tokens["Android"] ~= nil then
        ua.OS = Android
        ua.Tablet = string.find(string.lower(userAgent), "tablet", 1, true)
    elseif tokens["iPhone"] ~= nil then
        ua.OS = IOS
        ua.Device = "iPhone"
        ua.Mobile = true
    elseif tokens["iPad"] ~= nil then
        ua.OS = IOS
        ua.Device = "iPad"
        ua.Tablet = true
    elseif tokens['Windows NT'] ~= nil then
        ua.OS = Windows
        ua.OSVersion = tokens['Windows NT'] == nil and "" or tokens['Windows NT']
        ua.Desktop = true
    elseif tokens['Windows Phone OS'] ~= nil then
        ua.OS = WindowsPhone
        ua.OSVersion = tokens['Windows Phone OS'] == nil and ""  or tokens['Windows Phone OS']
        ua.Mobile = true
    elseif tokens['Macintosh'] ~= nil then
        ua.OS = MacOS
        ua.Desktop = true
    elseif tokens['Linux'] ~= nil then
        ua.OS = Linux
        ua.OSVersion = tokens[Linux] == nil and "" or tokens[Linux]
        ua.Desktop = true
    elseif tokens['Cros'] ~= nil then
        ua.OS = ChromeOS
        ua.OSVersion = tokens['CrOS'] == nil and "" or tokens['CrOS']
        ua.Desktop = true
    end

    if tokens['Googlebot'] ~= nil then
        ua.Name = Googlebot
        ua.Bot = true
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['Applebot'] ~= nil then
        ua.Name = Applebot
        ua.Version = tokens[Applebot]
        ua.Bot = true
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
        ua.OS = ""
    elseif tokens['Opera Mini'] ~= nil and tokens['Opera Mini'] ~= "" then
        ua.Name = OperaMini
        ua.Version = tokens[OperaMini]
        ua.Mobile = true
    elseif tokens['OPR'] ~= nil and tokens['OPR'] ~= "" then
        ua.Name = Opera
        ua.Version = tokens['OPR']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['OPT'] ~= nil and tokens['OPT'] ~= "" then
        ua.Name = OperaTouch
        ua.Version = tokens['OPT']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['OPiOS'] ~= nil and tokens['OPiOS'] ~= "" then
        ua.Name = Opera
        ua.Version = tokens['OPiOS']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['CriOS'] ~= nil and tokens['CriOS'] ~= "" then
        ua.Name = Chrome
        ua.Version = tokens['CriOS']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['FxiOS'] ~= nil and tokens['FxiOS'] ~= "" then
        ua.Name = Firefox
        ua.Version = tokens['FxiOS']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['Firefox'] ~= nil and tokens['Firefox'] ~= '' then
        ua.Name = Firefox
        ua.Version = tokens[Firefox]
        ua.Mobile = tokens['Mobile'] == nil and false or true
        ua.Tablet = tokens['Tablet'] == nil and false or true
    elseif tokens['Vivaldi'] ~= nil and tokens['Vivaldi'] ~= '' then
        ua.Name = Vivaldi
        ua.Version = tokens[Vivaldi]
    elseif tokens['MSIE'] ~= nil then
        ua.Name = InternetExplorer
        ua.Version = tokens['MSIE']
    elseif tokens['EdgiOS'] ~= nil and tokens['EdgiOS'] ~= "" then
        ua.Name = Edge
        ua.Version = tokens['EdgiOS']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['Edge'] ~= nil and tokens['Edge'] ~= '' then
        ua.Name = Edge
        ua.Version = tokens['Edge']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['Edg'] ~= nil and tokens['Edg'] ~= '' then
        ua.Name = Edge
        ua.Version = tokens['Edg']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['EdgA'] ~= nil and tokens['EdgA'] ~= '' then
        ua.Name = Edge
        ua.Version = tokens['EdgA']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['bingbot'] ~= nil and tokens['bingbot'] ~= '' then
        ua.Name = Bingbot
        ua.Version = tokens['bingbot']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['YandexBot'] ~= nil and tokens['YandexBot'] ~= '' then
        ua.Name = 'YandexBot'
        ua.Version = tokens['YandexBot']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['SamsungBrowser'] ~= nil and tokens['SamsungBrowser'] ~= '' then
        ua.Name = 'Samsung Browser'
        ua.Version = tokens['SamsungBrowser']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['HeadlessChrome'] ~= nil and tokens['HeadlessChrome'] ~= '' then
        ua.Name = HeadlessChrome
        ua.Version = tokens['HeadlessChrome']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
        ua.Bot = true
    elseif _M.existsAny(tokens, "AdsBot-Google-Mobile", "Mediapartners-Google", "AdsBot-Google") then
        ua.Name = GoogleAdsBot
        ua.Bot = true
        ua.Mobile = ua.OS == Android or ua.OS == IOS
    elseif tokens['Yahoo Ad monitoring'] ~= nil then
        ua.Name = 'Yahoo Ad monitoring'
        ua.Bot = true
        ua.Mobile = ua.OS == Android or ua.OS == IOS
    elseif tokens['XiaoMi'] ~= nil then
        local miui = tokens['XiaoMi']
        if mstr.startswith(miui, 'MiuiBrowser') then
            ua.Name = 'Miui Browser'
            ua.Version = mstr.trimPrefix(miui, "MiuiBrowser/")
            ua.Mobile = true
        end
    elseif tokens['FBAN'] ~= nil then
        ua.Name = FacebookApp
        ua.Version = tokens['FBAN']
    elseif tokens['FB_IAB'] ~= nil then
        ua.Name = FacebookApp
        ua.Version = tokens['FBAV'] == nil and "" or tokens['FBAV']
    elseif _M.tbStartsWith(tokens, 'Instagram') then
        ua.Name = InstagramApp
        ua.Version = _M.findInstagramVersion(tokens)
    elseif tokens['BytedanceWebview'] ~= nil then
        ua.Name = TiktokApp
        ua.Version = tokens['app_version'] == nil and "" or tokens['app_version']
    elseif tokens['HuaweiBrowser'] ~= nil and tokens['HuaweiBrowser'] ~= '' then
        ua.Name = 'Huawei Browser'
        ua.Version = tokens['HuaweiBrowser']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens[Chrome] ~= nil and tokens[Safari] ~= nil then
        local name = _M.findBestMatch(tokens, true)
        if name ~= '' then
            ua.Name = name
            ua.Version = tokens[name]
        else
            ua.Name = Chrome
            ua.Version = tokens['Chrome']
            ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
        end
    elseif tokens['Chrome'] ~= nil then
        ua.Name = Chrome
        ua.Version = tokens['Chrome']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['Brave Chrome'] ~= nil then
        ua.Name = Chrome
        ua.Version = tokens['Brave Chrome']
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    elseif tokens['Safari'] ~= nil then
        ua.Name = Safari
        local v = tokens['Version']
        if v ~= nil and v ~= "" then
            ua.Version = v
        else
            ua.Version = tokens['Safari'] == nil and "" or tokens['Safari']
        end
        ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
    else
        if ua.OS == 'Android' and tokens['Version'] ~= nil and tokens['Version'] ~= '' then
            ua.Name = 'Android browser'
            ua.Version = tokens['Version'] == nil and "" or tokens['Version']
            ua.Mobile = true
        else
            local name = _M.findBestMatch(tokens, false)
            if name ~= '' then
                ua.Name = name
                ua.Version = tokens[name] == nil and "" or tokens[name]
            else
                ua.Name = userAgent
            end
            ua.Bot = string.find(string.lower(ua.Name), "bot", 1, true) == nil and false or true
            ua.Mobile = _M.existsAny(tokens, "Mobile", "Mobile Safari")
        end
    end
    if ua.OS == Android then
        ua.Mobile = true
    end
    if ua.Tablet then
        ua.Mobile = false
    end

    if not ua.Bot then
        --ua.Bot = ua.URL ~= ""
    end

    if not ua.Bot then
        if ua.Name == Twitterbot or ua.Name == FacebookExternalHit then
            ua.Bot = true
        end
    end
    return ua
end

function _M.findInstagramVersion(tokens)
    for k, v in pairs(tokens) do
        if mstr.startswith(k, "Instagram") then
            local ver = _M.findVersion(v)
            if ver ~= nil then
                return ver
            else
                local ver2 = _M.findVersion(k)
                if ver2 ~= nil then
                    return ver2
                end
            end
        end
    end
    return ""
end

function _M.findVersion(str)
    local ver = string.match(str, '[_%d%.]+')
    if ver ~= nil then
        return string.gsub(ver, " ", ".")
    end
    return nil
end

function _M.findBestMatch(tokens, withVerOnly)
    local n = 2
    if withVerOnly then
        n = 1
    end

    local ignores = {Chrome, Firefox, Safari, "Version", "Mobile", "Mobile Safari", "Mozilla", "AppleWebKit", "Windows NT", "Windows Phone OS", Android, "Macintosh", Linux, "GSA", "CrOS", "Tablet"}

    for i=1,n do
        for k, v in pairs(tokens) do
            if _M.tbIn(ignores, k) then
            else
                local firstCharCode = string.byte(k:sub(1,1))
                if #k ~= 0 and firstCharCode >= 48 and firstCharCode <= 57 then
                    break
                end

                if i == 1 then
                    if v ~= nil and v ~= '' then
                        return k
                    end
                else
                    return k
                end
            end
        end
    end
    return ''
end

function _M.tbIn(tb, item)
    for _, v in pairs(tb) do
        if item == v then
            return true
        end
    end

    return false
end

function _M.tbStartsWith(tokens, prefix)
    for k, _ in pairs(tokens) do
        if mstr.startswith(k, prefix) then
            return true
        end
    end
    return false
end

function _M.existsAny(tokens, ...)
    local args = {...}
    for _, k in pairs(args) do
        for data, _ in pairs(tokens) do
            if data == k then
                return true
            end
        end
    end
    return false
end

function _M.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. _M.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function _M.parseUserAgent(userAgent)
    local tokens = {}
    local slash = false
    local isURL = false

    local buff = {}
    local val = {}

    local parOpen = false
    local braOpen = false

    --    local byteUa = { utf8.byte(userAgent, 1, -1) }
    local byteUa = { string.byte(userAgent, 1, -1) }
    for i, c in pairs(byteUa) do
        if c == 41 then -- )
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            parOpen = false
        elseif (parOpen or braOpen) and c == 59 then  -- ;
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
        elseif c == 40 then -- (
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            parOpen = true
        elseif c == 91 then -- [
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] =v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            braOpen = true
        elseif c == 93 then -- ]
            local k,v =_M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            braOpen = false
        elseif slash and c == 32 then
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
        elseif slash then
            table.insert(val, c)
        elseif c == 47 and not isURL then
            local nowBuffStr = string.char(unpack(buff))
            if i ~= #byteUa and byteUa[i+1] == 47 and (mstr.endswith(nowBuffStr, "http:") or mstr.endswith(nowBuffStr, "https:")) then
                table.insert(buff, c)
                isURL = true
            else
                slash = true
            end
        else
            table.insert(buff, c)
        end
    end
    local k, v = _M.addToken(buff, val, slash, isURL)
    if k ~= nil then
        tokens[k] = v
    end
    buff = {}
    val = {}
    slash = false
    isURL = false
    return tokens
end

function _M.addToken(buff, val, slash, isURL)
    if #buff ~= 0 then
        local s = mstr.str_trim(string.char(unpack(buff)))
        if not _M.ignore(s) then
            if isURL then
                s = mstr.trimPrefix(s, "+")
            end

            if #val == 0 then
                local key, ver = _M.checkVer(s)
                return key, ver
            else
                return s, mstr.str_trim(string.char(unpack(val)))
            end
        end
    end
end

function _M.checkVer(s)
    local i = mstr.findLastOccurrence(s, " ")
    if i == nil then
        return s, ""
    end
    local mdata = string.sub(s, 1, i-1)
    local os1 = {"Linux", "Windows NT", "Windows Phone OS", "MSIE", "Android"}
    for _, v in pairs(os1) do
        if mdata == v then
            return mdata, string.sub(s, i+1)
        end
    end

    if mdata == "CrOS x86_64" or mdata == "CrOS aarch64" then
        local j = mstr.findLastOccurrence(mdata, " ")
        return string.sub(s, 1, j-1), string.sub(s, j+1, i-1)
    end

    return s, ""
end

function _M.ignore(s)
    local tags = {"KHTML, like Gecko", "U", "compatible", "Mozilla", "WOW64", "en", "en-us", "en-gb", "ru-ru"}
    for _, v in pairs(tags) do
        if s == v then
            return true
        else
            return false
        end
    end
end


return _M
