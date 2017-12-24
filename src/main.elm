port module Main exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Navigation
import Regex
import UrlParser


port urlChange : String -> Cmd msg


type Msg
    = ChangeLocation String
    | UrlChange Navigation.Location


type alias Model =
    { route : Route
    , history : List String
    , titleHistory : List String
    , location : Navigation.Location
    , version : String
    , title : String
    }


type Route
    = Top
    | Section1
    | Section2
    | Section3
    | Sitemap
    | NotFound


capitalize : String -> String
capitalize str =
    case String.uncons str of
        Nothing ->
            str

        Just ( firstLetter, rest ) ->
            let
                newFirstLetter =
                    Char.toUpper firstLetter
            in
            String.cons newFirstLetter rest


sections :
    { section1 : { name : String }
    , section2 : { name : String }
    , section3 : { name : String }
    }
sections =
    { section1 =
        { name = "Parts"
        }
    , section2 =
        { name = "Videos"
        }
    , section3 =
        { name = "Trains"
        }
    }


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map Top UrlParser.top
        , UrlParser.map Section1 (UrlParser.s sections.section1.name)
        , UrlParser.map Section2 (UrlParser.s sections.section2.name)
        , UrlParser.map Section3 (UrlParser.s sections.section3.name)
        , UrlParser.map Sitemap (UrlParser.s "sitemap")
        ]


routeToPath : Route -> String
routeToPath route =
    case route of
        Top ->
            ""

        Section1 ->
            sections.section1.name

        Section2 ->
            sections.section2.name

        Section3 ->
            sections.section3.name

        Sitemap ->
            "sitemap"

        NotFound ->
            "notFound"


type alias Train =
    { id : String
    , imageCorner : Maybe String
    , imageFront : Maybe String
    , imagePackageBack : Maybe String
    , imagePackageFront : Maybe String
    , imageSide : Maybe String
    , name : String
    , nameJa : String
    , officialPage : String
    , officialPageJa : String
    , wikipedia : String
    , wikipediaJa : String
    , imageReal : Maybe String
    , imageRealAttribution : Maybe String
    }


trains : List Train
trains =
    [ { id = "SuperViewOdoriko"
      , name = "Super View Odoriko"
      , nameJa = "スーパービュー踊り子"
      , wikipedia = "https://en.wikipedia.org/wiki/Odoriko"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/踊り子_(列車)"
      , officialPage = "http://www.jreast.co.jp/train/express/odoriko.html"
      , officialPageJa = "https://www.jreast.co.jp/e/routemaps/superviewodoriko.html"
      , imageFront = Nothing
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "SuGBaYkoCEbN1UgVsye0Npn2iUK0RNBzUB34LpVo2fI6P7hZpTPl9KGNJVwBbRx2TEmqf2lcxAMA1oJD2A22lTyfy0fadUE1CZkSIxfDTxNwi3v3GQ9YJtd3NVO1I2eS8b_JQv87gQ"
      , imageRealAttribution = Just "By TC411-507 - 投稿者自身による作品, CC 表示-継承 3.0, https://commons.wikimedia.org/w/index.php?curid=8752829"
      }
    , { id = "DrYellow"
      , name = "Shinkansen 923 Dr. Yellow"
      , nameJa = "新幹線923形 ドクターイエロー"
      , wikipedia = "https://en.wikipedia.org/wiki/Doctor_Yellow"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/ドクターイエロー"
      , officialPage = ""
      , officialPageJa = ""
      , imageFront = Nothing
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "FQyIpanix-Ph3l1nAcIocd67CCrZBY01IhTZOk4FTtaO2OrJv3MmyZrTxkBUL-pDUNhuDyxVOO5tD0ByOP8lRqF3mtJ9vB0ZOxIU39k6bX7gQ-pEnHjhar7qlSrr30ieHL1IsT39fg"
      , imageRealAttribution = Just "By オリジナルのアップロード者は日本語版ウィキペディアの流風さん - ja.wikipedia からコモンズに移動されました。, CC 表示-継承 3.0, https://commons.wikimedia.org/w/index.php?curid=10056573"
      }
    , { id = "Yamanote"
      , name = "E231-500 Yamanote line"
      , nameJa = "E231系500番台 山手線"
      , wikipedia = "https://en.wikipedia.org/wiki/Yamanote_Line"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/山手線"
      , officialPage = ""
      , officialPageJa = ""
      , imageFront = Just "09l0vremwjCeTVQZ4yKOGl5nKmmv6GKMUR0I1CGHPYCzH6oIcHHW8jfjWZEL_Qs2muGbqO3kcmhOgC2VsOlEEn-UgibkmOgs1vq5GpPiJKWLby_BAPa56sljws_J08govRPNmIvA1w"
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "44M5fCQ59Y39vv2OL7L7nU7R9ZSRaXokofgPkxQX04RezrC29G7JLTdyJBeL6UtUWVL0VE8hIHgI5BObb3IwGGJus4_X65Mh-1nSSY90OIn-Jl7ih6RyuJT5b9i6_q3cYG67_ltOjA"
      , imageRealAttribution = Just "By Tennen-Gas - Own work, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=6251929"
      }
    , { id = "Orange"
      , name = "201 \"Tokyo ⇔ Takao\""
      , nameJa = "201系 中央特快 走行区間「東京⇔高尾」"
      , wikipedia = "https://en.wikipedia.org/wiki/201_series"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/国鉄201系電車"
      , officialPage = ""
      , officialPageJa = ""
      , imageFront = Just "Uwl1dN0a-3ygod2JKIc293AvuySDGU9qPHikxTR6P9Y_lHZi4WC52w2QqzHXa5tc-lL7RyZnLj49C6aE0Yc2m6f0BIDqoaYl9UzZcIoGGr2G_Rgjoy0O_1yC-yDoo0pcXYIk6QRY3w"
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "m0N1kG2iI2uXgnkWamu1ZFV5k5WbQrNIY-vA6H7356gaiqB-18s1zR9v5fHga1Bpl9ntXeRPXYcmc3eynrlEq870JIqKVacwQkS0RiVymDQ2MaZjs4s7Nivxn1bvOtmD81HQab609w"
      , imageRealAttribution = Just "CC 表示 3.0, https://ja.wikipedia.org/w/index.php?curid=159921"
      }
    , { id = "Green"
      , name = "Kiha 71 Yufuin no Mori"
      , nameJa = "キハ71系 ゆふいんの森"
      , wikipedia = "https://en.wikipedia.org/wiki/Yufuin_no_Mori"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/ゆふ_(列車)"
      , officialPage = ""
      , officialPageJa = ""
      , imageFront = Just "Fg2anKuExe6urrzyTPNIKOIR_-R0tg30yoZtldMk8qClA4htVvCGK0nqG0_28HcViza5S-wOP5JDZTi0nwalo_-b-w4DlE_i11cp3PSa7nGLZdnUDYEN3xz9w3zSBGz0g0gz7uvTmA"
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "RT8wkNCmctTr9lVOxGYOYp2Jc9-piA0ljIPCwBrOt9mEMH3oDlur2kBMhp5XEr0a1oxTWfvKMHzUp4ZLHmfMJtEEsBw_rdAvkGVYFT9dsOyfFtD1YhWIdcXyd6OQNdvUJ8fFkLusfg"
      , imageRealAttribution = Just "By Takasunrise0921 - ja:File:Yuhuinnomori.jpg, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=1208285"
      }
    , { id = "Shinkansen"
      , name = "E5 Shinkansen Hayabusa · Hayate · Yamabiko"
      , nameJa = "E5系新幹線 はやぶさ・はやて・やまびこ"
      , wikipedia = ""
      , wikipediaJa = "https://ja.wikipedia.org/wiki/はやぶさ_(新幹線)"
      , officialPage = ""
      , officialPageJa = ""
      , imageFront = Just "yj3JqPG6nisIR1Fbe8KYWRR0P69uc-_p7cziPZLz6n5lcSA6Grx4y0cmXQgYKyC3Dtir9BNw2htfhBxybQFi5bbrWbPJV4Zr8vXyfWa0Pa5KusGYurP2sRn4yqXw2KYFknm1hLgf_w"
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "1fP4pZ6IQi8qW3ED42-lSg3NHCyqR6TyDFDrBZEbbNAEyGLkoWq3d7hcjqeKoqM9dh1UKQlhmPXjglw6ZCTKkCLMVbaW9mt1t0HkDhSLVgKWp4Cg1eAfbNaMEil92ZDw1h2XcmAu1Q"
      , imageRealAttribution = Just "By Nanashinodensyaku - 投稿者自身による作品, CC 表示-継承 4.0, https://commons.wikimedia.org/w/index.php?curid=37732270"
      }
    , { id = "Nex"
      , name = "E259 Narita Express"
      , nameJa = "E259系 成田エクスプレス"
      , wikipedia = "https://en.wikipedia.org/wiki/E259_series"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/JR東日本E259系電車"
      , officialPage = ""
      , officialPageJa = ""
      , imageFront = Just "7FaJBeVDcuvLRsNToWjSeQNZcbYm3xrfw4FuhpH4ZtDwRe3BrluVvxxujFmVRJzU1KFmutp7US3IoPiJlFQAWtSjcjkptwsWzqbiFDlEcT3Yq1w9WVd1IRQcMocM6VItlqGqJWAC_w"
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      , imageReal = Just "OwctbEA1tNJtCyTFtWRqSP4TjLdbndZhYJgbqd5RDXF7v9y-GEY2v0P6s693NK5xGOulaZ6eM5Hb2lF07HV-x0Y7xJ2qYnHwqhu7hD0HkufIRo3q-Fj3XBKp8snj0KlE0gstrdwxoQ"
      , imageRealAttribution = Just "By 名無し野電車区 (Nanashino Denshaku) - Own work, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=22155966"
      }
    , { id = "SL"
      , name = "JNR C11 Steam Locomotive"
      , nameJa = "C11蒸気機関車"
      , wikipedia = "https://en.wikipedia.org/wiki/JNR_Class_C11"
      , wikipediaJa = "https://ja.wikipedia.org/wiki/国鉄C11形蒸気機関車"
      , officialPage = ""
      , officialPageJa = ""
      , imageReal = Just "PfuK_DE7gZKmg-xSirznK-O8zr9kOlBV4ULY-QxHbAkw-tHbUnKUtGSn0BUIdrc3jnqgh9WbtTveT8zCspPHQU6CHX-5hCHk2xgnIKhKPJz9O7WKsDh1yyO_pAuwxRyeLLJYazFUUw"
      , imageRealAttribution = Just "By Kone - 投稿者自身による作品, CC 表示-継承 3.0, https://commons.wikimedia.org/w/index.php?curid=787781"
      , imageFront = Nothing
      , imageSide = Nothing
      , imageCorner = Nothing
      , imagePackageFront = Nothing
      , imagePackageBack = Nothing
      }
    ]


parts :
    List
        { id1 : number
        , id2 : number1
        , id3 : number2
        , image1 : String
        , image2 : String
        , name : String
        }
parts =
    [ { id1 = 4
      , name = "Riser Train Track"
      , id2 = 31
      , id3 = 4549131120769
      , image1 = "F1mimnqLSqnGtNnkIjZzsUGXN8GySy2ktrsucVRKhzQ2cFFYQwj7qxTfknNae62DljmSNXsbXzyjm3M_66POa8QzEFOKeWvQJN-iyGlzXYvxVNj8n8hGYk8c5OWGzY8DfKNQ5ohBOQ"
      , image2 = "2vdMJ1YbU019mtNKmDlzi4d4wO89PQOo5hNldPGBosS0Sgc41QqtdOf9k2YmAbSfczaAoifP7VTceNP0K9Zzd4dMdBr013BDU8epePVc8F0swuwj8OCzO6gtk98O5VFVDl6IK9BTTA"
      }
    , { id1 = 16
      , name = "Double Line Elevated Tier"
      , id2 = 108
      , id3 = 4549131326444
      , image1 = "u0SO657257dskAP8U1xdMH6-iV6VJcxoWd6uVnlspswSenLL2DcjdYI4CsPvzBP88ilJd7L0HyYlXXcnIG9x5TXsBYDOpkdeJxLd14CkBBqgIjKWqcoo-PFuLYfc802JvUiX4qusJQ"
      , image2 = "RVW4R-WXOmSPnG9l6VJXXSuJ8IX9pHvc7f2htOXipu57gynhgLhr6XcxmkNkt0H54BJH_TJWcvH_T7c3ZG9T67e6DvAmuY5OmGlRbSCC8gS_osOjE7Fq7xsVtuFGAuU6jHijTMnzrw"
      }
    , { id1 = 0
      , name = "Dr. Yellow"
      , id2 = 89
      , id3 = 4549131121506
      , image1 = "YMZQqIAp0A0Pv8yl42m8tOxDyLYZ4FgjOzZ82gMaF_0YwBN_3uTk97w30tv-F6elWtPxSIKZwrazMihhxWevL62eqrlSAMEW_EvA_5jGJbize_0z3eSs4ncLAaiWzL0_mkMf6ztrwA"
      , image2 = "phK31HG2c54l9bVNsvGE0BGsLfq8JLx9I3_HSFg0Jv0Qx2uUKwwK6kNj1rh4mhBNOfCCDbyP-ZkyisJT7ttSzpuf4Tfv60D1NjcrH5UxjqxFOSXpFvYTi5-Sb-NZZSAwpBsLT0lHqA"
      }
    , { id1 = 9
      , name = "Tunnel"
      , id2 = 53
      , id3 = 4549131121148
      , image1 = "ohABrpclz5i7OXhfIYzhvkUFJXF6-yjuBji32RLxEEjxoMWVv9etxK1cIWIQUmM0kYOXHNouElbsdGqa-AZf-PXuf4v49sW9jM6OM9WX28noAQjXEZ5jhTq1zZHKaVMCqmLWE8O-xQ"
      , image2 = "HUFlNemLdSkYK9hmUtrp2S2yMAQis_GFzq0iJVnh3xvzvLHJyAmrNP-bu-4_MsY_8wJZ2Ku5BoRX0UUq5sz5k7gFDe82UaLQ_Q1zsNSgg7BCc8hWg8ZYe0UzQBcwiCie5uGEetnFBA"
      }
    , { id1 = 1
      , name = "Elevated Tier"
      , id2 = 45
      , id3 = 4549131121063
      , image1 = "us6elnjD43EijshGuCoshozWYZuwp3bfjEE22aESsRzDNAYpZiITqmfmYbquba4YkRimXHBvbnZKVi7tC2ygW1rf6N_bPNxXxOhoYT3JVsBuBxgRmDHeBUDW2Q6MaQq4ar2r7Bk-sw"
      , image2 = "cVpaUTqbkKbyJGX-PXkuLTY0Djha74nMDx_FERhPI_Png8ftKZEwssS7Sr5TQPTND6hcs8C_Z-atfALLA1SWy5hpqaUywPLPKXv0h-E5lLWFRdweAQ-tRGdHMabGEH2PJfMcW0yY5w"
      }
    , { id1 = 3
      , name = "Curve Train Track"
      , id2 = 29
      , id3 = 4549131120745
      , image1 = "yj2fCc7lylD6fiQIxI6oVqiC1L9QgLVPvO0YJmfApSFy9m59rBDcP7zRFEMhnCaYfjfOqCpwkjnYdnvwfJTHQR4jcnkOQ46ydFTHeLhtYNNkYfryQlJ5RF-6mMIQM4CgHC0wA1Ke2A"
      , image2 = "lHrv5OgVzceJn9Ygd2FIAobmDo-0GXy6RAgMQygnE3wsyyr0FC6smhSFtJ3rML5sAs_aV49cR-R2cpIE3h7ghwcD-2n-aNDbdk3JVdCVk6pOwxdUb_sbCksFFujxJpsPmrvm3yBS7Q"
      }
    , { id1 = 0
      , name = "Super View Odoriko"
      , id2 = 64
      , id3 = 4549131121254
      , image1 = "JYw728zCX_1rjBCKo9HHrnOCoCrhivFj8iXyz3--_vBzMVtYv41P7u3P39oTd0-MOhOtveNM-G_oA6a0gt2SOIcpakpgZLLb4iSMfLW89GUJcwMZP4CkXDnuDIa02ofkqIQ_oQVQng"
      , image2 = "op_LGTsUcObTMIhTLdjyfNfrDW-_gY8JmaJ4gAZiRSFBFMWTboW8JCWltkzjjFO8vgVyv2EJA92HalRa8Dj4M7Dl3AjmjoSrZDaHMwSCPvxXKTvP6AbGGwHQXFJOmK_66xxGFGT2Ig"
      }
    , { id1 = 0
      , name = "Dr. Yellow"
      , id2 = 88
      , id3 = 4549131121490
      , image1 = "rDD2G4dJGlR5wKCUsZGWhz8s2yem0-5J03SbUOdjYEKrktFb0KBtKwxcm0B8-FYOurh03tUjXM3XjZFHJWUqg44WuQmixuua0jq9y5Rv4H6ER1hVOu_b9Q-1XqAQzsUboDrK20e-OA"
      , image2 = "qgIKbZMl0LhTuyIcyZlgbmj-0m334Ljp-KzindWO7r5TNqlJziDftlyPZDCvCclScVlThlygqfwlOPv9Ij6R1NMmEzNVYQdHuycbyJZ5o8kCH9IVma3Te7NTfehGZceM4QN0u8Rm9g"
      }
    , { id1 = 0
      , name = "Super View Odoriko"
      , id2 = 65
      , id3 = 4549131121261
      , image1 = "K1I0Fv_T0CEu0wdnVTsKToMk9vDWmHs2zev-7-XSVAfGG34F7c7-K8fM9PjDJx95QTV9xbOVUZ2WIYxpfUD7oRb767G2U8vHBNJKdAlSCjy4Pasnbitdx_chdf1O7Qr1FsGYDP0xpA"
      , image2 = "fWPJdKVFI8LOBvS7X1YAYbeMLCldwe9dY-QCFX7IurhA3XbG7zvdTJwQadmTJ_ia__tFTRy2O3L_gfyFwzf0pwXyFeM5aBjkZl_4yj4lU6P2qP8IngcvMyrFuaE2K2LWexsnjYPTuA"
      }
    , { id1 = 0
      , name = "Dr. Yellow"
      , id2 = 90
      , id3 = 4549131121513
      , image1 = "8YRehvAiRCxGG_n0ytRHO6yD5e9VMaZRiL6lhtWTTOHOqSMmClq7CNq86fMeguM1-x1SAWK5nceOVK2sjlqm13RfAfziOw3_YM0OTgV7AGSNjItdEdiTJ2-obO7cgxtQ7ztUeGGo_w"
      , image2 = "t7tYEHGPMno5dT4RUoBJ1etZLhvpcigU_ACYmIKiKD8er8JEn-dFCGnpQrNAp72xW4cHOWr8WENKGvVRzCBuM-CaC2VxfSPEy6rqGjAcOFtWDqgcLJjdXxyv4pSqWBjl3kXm1CjDLA"
      }
    , { id1 = 1
      , name = "Straight Train Track"
      , id2 = 28
      , id3 = 4549131120738
      , image1 = "QnHvBytJ0jpI2W3gRSuZNxhLOZPky2REMhC1iewHj1dcR3ZKDc4R_blt_i9W2j_N1bCR8o0ArXm4dLxO2zhfyxn8TbrYZRsfWZd9qCDP276J4h8vqZqGtrQYTPPkSJ2VLEtKA210jQ"
      , image2 = "E1G6ZbMOgM_8-hre_tAYy_2FC5Wn0DLmLh7dSJLWTSZheyE3_qxNqef6kLEhW0zeKt-ZYtV_WZmvt0apWiwdzG142ey4l6NGl2pjw_9lR6PYGwOUxByBmms4-X5v9ceyhDP0cDn7XQ"
      }
    , { id1 = 4
      , name = "Bridge Column"
      , id2 = 48
      , id3 = 4549131121094
      , image1 = "2SL7ZWxWsYz9ilrhoNvoym7CwqREIoj0kXjEHF73cY5oBytjqLEhNZK88KwvMPj9xkMuHVVZhHCPfsxvPJNmPnY7QLy0CgqtcRVaXT-Oyjat_MSdJcgspTfDY-sZgywCEZuz0sSD2Q"
      , image2 = "ClLRMGL9RomF2tUD03llBUdfWskdHsntla7OvegH13FnfFySXfPn1JDAJgVWUAgrhvQ7yfWkyLi2BHEVzaEL9JEYwj4shLzYyr-pjxgsY15X2IUlTkUtIanTWyTXjGbDetNhzcZmIg"
      }
    , { id1 = 15
      , name = "Turnplate"
      , id2 = 109
      , id3 = 4549131326451
      , image1 = "L8OgsuTQgljBOLgFxo2FFngPObFxaT7fO6GBcd52QyY368X-bEfEHoeZRb3SGhG0647Pxn0ukU6R3qDaiV9gL0FOKjKOKGkzdhNi9CpXKLpVX8nvculY696fy4d1LIMJNIyrPaRoZQ"
      , image2 = "PSzOKiYVp1KrflYK4gXl1mOwIID1nLkhzaeOVIKnCHvr6Tsx3XuSk1lExeU5hoPRNLcvDpAuGo4FehVzcz0rhqGtEnMday42m5hlX7FCRD5wWidPfXRtfSU5R6INF0Z0rsSuw540-A"
      }
    , { id1 = 8
      , name = "Cross Half Size Train Track"
      , id2 = 35
      , id3 = 4549131120806
      , image1 = "_PTAPuiFZ8hSDDqgSuhvyfeQyb1usHiWot8VHWezPQ6VvZNNV1a4QNjtLne4zgV2I7LxMbPwdk1i9s7n1MX1FTyBA-2by4B9Ju2Kb5ak4aQ4hkUHWP_tfi9twNPXU1GskpG0eRumSg"
      , image2 = "aadtlehbLBTGxg2uJFBvl8lvp1PNM9h3ZeTbbqyHVR2OXrZc7P4chNXjlwVsGPVta14_v6jRNInpBqkG9ZFF1dOObYGdWj-uLukVt3yHQIV7_R-SO068peEdZt5Mn_vVZe5iLC4xFg"
      }
    ]


parts2 :
    List
        { code : String
        , name : String
        , nameJa : String
        , number : Int
        , trainId : Maybe String
        , trainPart : Int
        }
parts2 =
    [ { code = "4549131121261"
      , name = "Super View Odoriko"
      , nameJa = "スーパービュー踊り子"
      , number = 65
      , trainPart = 2
      , trainId = Just "SuperViewOdoriko"
      }
    , { code = "4549131121513"
      , name = "Dr. Yellow"
      , nameJa = ""
      , number = 90
      , trainPart = 3
      , trainId = Just "DrYellow"
      }
    ]


locationToRoute : Navigation.Location -> Route
locationToRoute location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFound


updateTitleAndMetaDescription : Model -> Cmd msg
updateTitleAndMetaDescription model =
    urlChange (pageTitle model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation pathWithSlash ->
            ( model, Navigation.newUrl pathWithSlash )

        UrlChange location ->
            let
                newRoute =
                    locationToRoute location

                newHistory =
                    location.pathname :: model.history

                newModel =
                    { model | route = newRoute, history = newHistory, location = location }
            in
            ( newModel
            , updateTitleAndMetaDescription newModel
            )


onLinkClick : String -> Attribute Msg
onLinkClick path =
    onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (Json.Decode.succeed (ChangeLocation path))


view : Model -> Html Msg
view model =
    div [ id "app" ]
        [ node "style" [] [ text css ]
        , h1 [] [ text model.title ]
        , viewNavigation model

        -- , viewMetadata model
        , viewPage model
        ]


viewMetadata : Model -> Html msg
viewMetadata model =
    div [ id "metadata" ]
        [ p [ class "highlight" ] [ text ("Title: " ++ pageTitle model) ]
        , p [] [ text "V = Version, H = History length, A = Type A Ajax, B = Type B Ajax" ]
        , p []
            [ text "History: "
            , span []
                (List.map (\item -> span [ class "history" ] [ text item ])
                    (List.reverse model.history)
                )
            ]
        ]


pathToName : String -> String
pathToName path =
    if path == "" then
        "Home"
    else
        capitalize path


viewLink : Model -> String -> Route -> Html Msg
viewLink model path route =
    let
        url =
            "/" ++ path
    in
    li
        []
        [ if model.route == route then
            div [ class "selected" ] [ text (pathToName path) ]
          else
            a [ href url, onLinkClick url ] [ text (pathToName path) ]
        ]


viewNavigation : Model -> Html Msg
viewNavigation model =
    ul [ class "navigation" ]
        [ viewLink model "" Top
        , viewLink model sections.section1.name Section1
        , viewLink model sections.section2.name Section2
        , viewLink model sections.section3.name Section3
        , viewLink model "sitemap" Sitemap
        ]


viewPage : Model -> Html Msg
viewPage model =
    div []
        [ h2 []
            [ model.route
                |> routeToPath
                |> pathToName
                |> text
            ]
        , div []
            [ case model.route of
                Section1 ->
                    section1

                Section2 ->
                    section2

                Section3 ->
                    section3

                Top ->
                    viewTop

                Sitemap ->
                    textarea []
                        [ text
                            (routeToSurgeUrl Top
                                ++ "\n"
                                ++ routeToSurgeUrl Section1
                                ++ "\n"
                                ++ routeToSurgeUrl Section2
                                ++ "\n"
                                ++ routeToSurgeUrl Section3
                                ++ "\n"
                                ++ routeToSurgeUrl Sitemap
                            )
                        ]

                NotFound ->
                    text "Page not Found"
            ]
        ]


routeToSurgeUrl : Route -> String
routeToSurgeUrl route =
    "http://puchi.guupa.com/" ++ routeToPath route


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        model =
            initModel location
    in
    ( model
    , initCmd model location
    )


initModel : Navigation.Location -> Model
initModel location =
    { route = locationToRoute location
    , history = [ location.pathname ]
    , titleHistory = []
    , location = location
    , version = "9"
    , title = "The Daiso Petit Train Series - ザ・ダイソーのプチ電車シリーズ"
    }


pageTitle : Model -> String
pageTitle model =
    model.title


initCmd : Model -> Navigation.Location -> Cmd Msg
initCmd model location =
    Cmd.batch
        []


extractNumber : String -> String
extractNumber text =
    let
        number =
            Regex.find Regex.All (Regex.regex "\\d{1,2}") text
    in
    case List.head number of
        Nothing ->
            "[NaN]"

        Just data ->
            data.match


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []


mainBrightColor : String
mainBrightColor =
    "#7effca"


mainDarkColor : String
mainDarkColor =
    "#4c9275"


highlightColor : String
highlightColor =
    "#deff7e"


css : String
css =
    """body {
    color: #555;
    margin: 10px;
    font-family: sans-serif;
    background-color: #ccc;
}
.navigation li {
    display: inline-block;
}
.history {
    display: inline-block;
    background-color: """ ++ highlightColor ++ """;
    margin: 0 2px;
}

.navigation {
    padding: 0;
}
.navigation li {
    display: inline-block;
}
.navigation a, .navigation div {
    padding: 10px;
}
.navigation .selected {
    background-color: """ ++ mainBrightColor ++ """;
    color: black;
}
h2 {
    color: """ ++ mainDarkColor ++ """;
    margin-bottom: 2em;
}
h1 {
    color: """ ++ mainDarkColor ++ """;
    font-size: 1em;
    border-bottom: 2px solid """ ++ mainDarkColor ++ """;
}
a {
    text-decoration: none;
    color: """ ++ mainDarkColor ++ """;
}
a:hover {
    background-color: """ ++ mainBrightColor ++ """;
    color: black;
}
.subAppHide .highlight{
    background-color: """ ++ highlightColor ++ """;
}
.subAppShow .highlight{
    transition: all 1000ms;
}
textarea {
    width: 100%;
    height: 80px;
}
#metadata {
    font-size: 2em;
    color: gray;
    font-family: monospace;
}
#metadata p {
    margin: 2px 0;
}
.viewTrainContainer {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
}

.viewTrain {
    border: 0px solid red;
    flex: 1 1 auto;
    text-align: center;
}

.viewTrain-front {
    clip-path: circle(50% at 50% 50%);
    height: 150px;
    width: 150px;
}
.viewTrain-real {
    max-width: 150px;
    max-height: 150px;
}
"""


viewTrain : Train -> Html msg
viewTrain train =
    let
        imageFront =
            case train.imageFront of
                Just string ->
                    img
                        [ src <| "https://lh3.googleusercontent.com/" ++ string ++ "=w150-h150-no"
                        , class "viewTrain-front"
                        ]
                        []

                Nothing ->
                    text ""

        imageReal =
            case train.imageReal of
                Just string ->
                    img
                        [ src <| "https://lh3.googleusercontent.com/" ++ string ++ "=w150-h150-no"
                        , class "viewTrain-real"
                        ]
                        []

                Nothing ->
                    text ""
    in
    div [ class "viewTrain" ]
        [ p [] [ text train.name ]
        , p [] [ text train.nameJa ]
        , imageFront
        , imageReal
        ]


viewPart :
    { d
        | id1 : a
        , id2 : b
        , id3 : c
        , image1 : String
        , image2 : String
        , name : String
    }
    -> Html msg
viewPart part =
    div [ class "viewPart" ]
        [ h2 [] [ text part.name ]
        , p [] [ text <| "Id 1: " ++ toString part.id1 ]
        , p [] [ text <| "Id 2: " ++ toString part.id2 ]
        , p [] [ text <| "Id 3: " ++ toString part.id3 ]
        , img
            [ src <| "https://lh3.googleusercontent.com/" ++ part.image1 ++ "=w150-h150-no"
            ]
            []
        , img
            [ src <| "https://lh3.googleusercontent.com/" ++ part.image2 ++ "=w150-h150-no"
            ]
            []
        ]


viewTop : Html msg
viewTop =
    div []
        [ div []
            [ p [] [ text """Petit Train is a cheap railway toy made by LEC, Inc. (http://lecinc.info/) and sold at 100 yen shops of Daiso (ザ・ダイソー). The Japanese name is プチ電車 ("puchi densha"). It is based on three-car trains running on plastic rails. The middle car has the engine that run on a single AA battery.""" ]
            , p [] [ text "Comments and Info at lucamug@gmail.com" ]
            ]
        , div [ class "viewTrainContainer" ] (List.map viewTrain trains)
        , ul []
            [ li []
                [ a [ href "https://ja.wikipedia.org/wiki/%E3%83%97%E3%83%81%E9%9B%BB%E8%BB%8A%E3%82%B7%E3%83%AA%E3%83%BC%E3%82%BA" ] [ text "Wikipedia page in Japanese" ]
                ]
            , li []
                [ a [ href "https://photos.app.goo.gl/10C4khv6csfkfQMn2" ] [ text "Photo Album" ]
                ]
            , li []
                [ a [ href "http://puchi.guupa.com" ] [ text "puchi.guupa.com" ]
                ]
            , li []
                [ a [ href "https://www.youtube.com/watch?v=AVJfzkGycLo" ] [ text "Official video" ]
                ]
            ]
        ]


youtube : Int -> Int -> String -> Html msg
youtube x y id =
    iframe
        [ width x
        , height y
        , src <| "https://www.youtube.com/embed/" ++ id
        , attribute "frameborder" "0"
        , attribute "gesture" "media"
        , attribute "allow" "encrypted-media"
        , attribute "allowfullscreen" "allowfullscreen"
        ]
        []


section1 : Html msg
section1 =
    -- Parts
    div [ class "viewPartContainer" ] (List.map viewPart parts)


section2 : Html msg
section2 =
    div []
        [ youtube 556 315 "Mv7KCTRA6UQ"
        , youtube 556 315 "AVJfzkGycLo"
        ]


section3 : Html msg
section3 =
    text """section1 content"""


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
