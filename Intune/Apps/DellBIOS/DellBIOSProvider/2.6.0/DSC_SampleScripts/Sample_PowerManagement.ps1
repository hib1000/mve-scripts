##########################################################################
# DELL PROPRIETARY INFORMATION
#
# This software is confidential.  Dell Inc., or one of its subsidiaries, has supplied this
# software to you under the terms of a license agreement,nondisclosure agreement or both.
# You may not copy, disclose, or use this software except in accordance with those terms.
#
# Copyright 2020 Dell Inc. or its subsidiaries.  All Rights Reserved.
#
# DELL INC. MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE SOFTWARE,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.
# DELL SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING,
# MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
#
#
#
##########################################################################

#$pwwd=Get-Content "c:\temp\userpwd.txt"
Configuration PowerManagementConfiguration
{
    Import-DscResource -ModuleName DellBIOSProvider
 
    Node localhost {
        PowerManagement PowerManagementSettings    #resource name
        {
          Category = "PowerManagement"
          BlockDefinition="1"
          AutoOnHr=15
          AutoOnMn=42
          AdvancedBatteryChargeConfiguration = "Tuesday"
          BeginningOfDay = "10:30"
          WorkPeriod = "15:45"
          PeakShiftDayConfiguration = "Saturday"
          StartTime = "10:30"
          EndTime = "12:30"
          ChargeStartTime = "13:30"          
          #Password = ""
          #SecurePassword=$pwwd.ToString()
          #PathToKey=""
        }

        PowerManagement PowerManagementSettings_next    #resource name
        {
          Category = "PowerManagement"
          BlockDefinition="2"
          PeakShiftDayConfiguration = "Sunday"
          StartTime = "10:30"
          EndTime = "12:30"
          ChargeStartTime = "19:45"          
          #Password = ""
          #SecurePassword=$pwwd.ToString()
        }
    }
}

# Call the configuration. 
# It will create a folder with the same name as configuration name (\POSTBehaviorConfiguration)and will contain mof output file.

PowerManagementConfiguration 

#Push Mof
Start-DscConfiguration -Path .\PowerManagementConfiguration\ -wait -verbose -debug -force


# SIG # Begin signature block
# MIIcOgYJKoZIhvcNAQcCoIIcKzCCHCcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD3DRvP4Ge+oqvb
# NPL4kJX6XrKBUkP4OtmxNABi9SvD46CCCsowggUyMIIEGqADAgECAg0Ah4JSYAAA
# AABR03PZMA0GCSqGSIb3DQEBCwUAMIG+MQswCQYDVQQGEwJVUzEWMBQGA1UEChMN
# RW50cnVzdCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdh
# bC10ZXJtczE5MDcGA1UECxMwKGMpIDIwMDkgRW50cnVzdCwgSW5jLiAtIGZvciBh
# dXRob3JpemVkIHVzZSBvbmx5MTIwMAYDVQQDEylFbnRydXN0IFJvb3QgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkgLSBHMjAeFw0xNTA2MTAxMzQyNDlaFw0zMDExMTAx
# NDEyNDlaMIHIMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjEo
# MCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdhbC10ZXJtczE5MDcGA1UE
# CxMwKGMpIDIwMTUgRW50cnVzdCwgSW5jLiAtIGZvciBhdXRob3JpemVkIHVzZSBv
# bmx5MTwwOgYDVQQDEzNFbnRydXN0IEV4dGVuZGVkIFZhbGlkYXRpb24gQ29kZSBT
# aWduaW5nIENBIC0gRVZDUzEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDCvTcBUALFjaAu6GYnHZUIy25XB1LW0LrF3euJF8ImXC9xK37LNqRREEd4nmoZ
# NOgdYyPieuOhKrZqae5SsMpnwyjY83cwTpCAZJm/6m9nZRIi25xuAw2oUGH4WMSd
# fTrwgSX/8yoS4WvlTZVFysFX9yAtx4EUgbqYLygPSULr/C9rwM298YzqPvw/sXx9
# d7y4YmgyA7Bj8irPXErEQl+bgis4/tlGm0xfY7c0rFT7mcQBI/vJCZTjO59K4oow
# 56ScK63Cb212E4I7GHJpewOYBUpLm9St3OjXvWjuY96yz/c841SAD/sjrLUyXE5A
# PfhMspUyThqkyEbw3weHuJrvAgMBAAGjggEhMIIBHTAOBgNVHQ8BAf8EBAMCAQYw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwEgYDVR0TAQH/BAgwBgEB/wIBADAzBggrBgEF
# BQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0MDAG
# A1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9jcmwuZW50cnVzdC5uZXQvZzJjYS5jcmww
# OwYDVR0gBDQwMjAwBgRVHSAAMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cuZW50
# cnVzdC5uZXQvcnBhMB0GA1UdDgQWBBQqCm8yLCkgIXZqsayMPK+Tjg5rojAfBgNV
# HSMEGDAWgBRqciZ60B7vfec7aVHUbI2fkBJmqzANBgkqhkiG9w0BAQsFAAOCAQEA
# KdkNr2dFXRsJb63MiBD1qi4mF+2Ih6zA+B1TuRAPZTIzazJPXdYdD3h8CVS1WhKH
# X6Q2SwdH0Gdsoipgwl0I3SNgPXkqoBX09XVdIVfA8nFDB6k+YMUZA/l8ub6ARctY
# xthqVO7Or7jUjpA5E3EEXbj8h9UMLM5w7wUcdBAteXZKeFU7SOPId1AdefnWSD/n
# bqvfvZLnJyfAWLO+Q5VvpPzZNgBa+8mM9DieRiaIvILQX30SeuWbL9TEU+XBKdyQ
# +P/h8jqHo+/edtNuajulxlIwHmOrwAlA8cnC8sw41jqy2hVo/IyXdSpYCSziidmE
# CU2X7RYuZTGuuPUtJcF5dDCCBZAwggR4oAMCAQICD3HnAZHCZ4Xw8xAzN3V0njAN
# BgkqhkiG9w0BAQsFADCByDELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3Qs
# IEluYy4xKDAmBgNVBAsTH1NlZSB3d3cuZW50cnVzdC5uZXQvbGVnYWwtdGVybXMx
# OTA3BgNVBAsTMChjKSAyMDE1IEVudHJ1c3QsIEluYy4gLSBmb3IgYXV0aG9yaXpl
# ZCB1c2Ugb25seTE8MDoGA1UEAxMzRW50cnVzdCBFeHRlbmRlZCBWYWxpZGF0aW9u
# IENvZGUgU2lnbmluZyBDQSAtIEVWQ1MxMB4XDTIwMTExOTIxNTUwOFoXDTIxMTIx
# MjIxNTUwN1owgdgxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIEwVUZXhhczETMBEGA1UE
# BxMKUm91bmQgUm9jazETMBEGCysGAQQBgjc8AgEDEwJVUzEZMBcGCysGAQQBgjc8
# AgECEwhEZWxhd2FyZTERMA8GA1UEChMIRGVsbCBJbmMxHTAbBgNVBA8TFFByaXZh
# dGUgT3JnYW5pemF0aW9uMR0wGwYDVQQLExRDbGllbnQgUHJvZHVjdCBHcm91cDEQ
# MA4GA1UEBRMHMjE0MTU0MTERMA8GA1UEAxMIRGVsbCBJbmMwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCtsUxaEbdP93k7fH+aROiSPIJ+YewmCSc4fIOo
# 4QeQvzVl2V9i5dS10Vl0pguq30l4EINnHd+8tMgIKwjiKRyuSjzSGv02HhnjIj4N
# ZGAGHAHOl67N8B2Tn2xJs+obpB6S6ZVDlTep30Oaif3wFh0lRPhXwZqmkZo4wPk/
# XTAAr6EvkNsF02BluYDqFYLztXBuTb6TFx/6jXjzN8z2GcYzb2p/LbnVGWeuyyvS
# YkY0z+8QlYezGbsD/5I/aIxi/6hoDhM9t1gmfFu8byeYF0iQv9HN//+yKPpHZ9NX
# cbuFG8yZssRrDMSE+TdDaF0hhywpyDzK2tQL9x9OVaSS8gxbAgMBAAGjggFjMIIB
# XzAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQPbg/plOi4U1vRuFqxMH8mepZ6vDAf
# BgNVHSMEGDAWgBQqCm8yLCkgIXZqsayMPK+Tjg5rojBqBggrBgEFBQcBAQReMFww
# IwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0MDUGCCsGAQUFBzAC
# hilodHRwOi8vYWlhLmVudHJ1c3QubmV0L2V2Y3MxLWNoYWluMjU2LmNlcjAxBgNV
# HR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmVudHJ1c3QubmV0L2V2Y3MxLmNybDAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwSwYDVR0gBEQwQjA3
# BgpghkgBhvpsCgECMCkwJwYIKwYBBQUHAgEWG2h0dHBzOi8vd3d3LmVudHJ1c3Qu
# bmV0L3JwYTAHBgVngQwBAzANBgkqhkiG9w0BAQsFAAOCAQEAiF7xd3GBxaI9u4RZ
# CEbblLpwzGcmBLvR0fiwgTASbadHYmOTPOYR3PsPsM5tQyLcdei9zser2TsHYNfk
# fmPXXA3C3TtUDzK6jKskniivaTa0DD51rKjiDGCJCaL6PuiaoM7koTmM2vJ+3miP
# rhqZF4dN9oB4/I7qKBCBHAr08VdD7nTP4lkSR54Bgim8I3mS4iEK2EPtRJzKDyqr
# jDlCyRY3EWocFqpnU4qoiMhUwK1CUNvqtTcQOzXhWSjHqPvfQlDINo6GrWadnByT
# yPrcgrfrIwrXkLxj99tvknAB17fFS1Xyku+PkevhkoOpdAWKogXOjrNwuO2etQou
# 8Pl8ODGCEMYwghDCAgEBMIHcMIHIMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRW50
# cnVzdCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdhbC10
# ZXJtczE5MDcGA1UECxMwKGMpIDIwMTUgRW50cnVzdCwgSW5jLiAtIGZvciBhdXRo
# b3JpemVkIHVzZSBvbmx5MTwwOgYDVQQDEzNFbnRydXN0IEV4dGVuZGVkIFZhbGlk
# YXRpb24gQ29kZSBTaWduaW5nIENBIC0gRVZDUzECD3HnAZHCZ4Xw8xAzN3V0njAN
# BglghkgBZQMEAgEFAKB8MBAGCisGAQQBgjcCAQwxAjAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqG
# SIb3DQEJBDEiBCCgzGFVz4jaODIArbxrSNF1Epj9HOQ2sq1GChoiOkqtODANBgkq
# hkiG9w0BAQEFAASCAQAUxEpnO8Y1SSnItIBqIp9wvkgbKnAS0KQCBtn3bDZLbvtV
# iVdtfrIygLnTtnM0SBwG98BMeNG9FuTN82EYiTHomxwCwxteHmxzcJn60iDPqIQo
# x9rY9IO9OUTYIxqhdJFwAkSRYy6wTT4wiLjlUy1WSAFA8iNNoMd8bFrcji1Gkyyf
# sh80vclgTa53ncSutbn3SfABPU3nIb39O3m2ls4lD67Ey8bhtdoaac4/SRMvycbI
# 7Lx1Tc/OGw82y/cctHuB4sQsmDAMvs6bsKjVz5em7RA/2ME3imM7wyTxCaj8QwWP
# 6xstepe5wGCTCAkltF8YjZFqehMCAKUnvgWGorGIoYIOPDCCDjgGCisGAQQBgjcD
# AwExgg4oMIIOJAYJKoZIhvcNAQcCoIIOFTCCDhECAQMxDTALBglghkgBZQMEAgEw
# ggEOBgsqhkiG9w0BCRABBKCB/gSB+zCB+AIBAQYLYIZIAYb4RQEHFwMwMTANBglg
# hkgBZQMEAgEFAAQgqZq9VpNW7hOFBAY5Mecxrt045ARMlauqxhLlsJIAeRECFEK2
# bMfZytj+8PokKvrJGBTHTIeKGA8yMDIxMDkwMjExNTQ0MFowAwIBHqCBhqSBgzCB
# gDELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8w
# HQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMTEwLwYDVQQDEyhTeW1hbnRl
# YyBTSEEyNTYgVGltZVN0YW1waW5nIFNpZ25lciAtIEczoIIKizCCBTgwggQgoAMC
# AQICEHsFsdRJaFFE98mJ0pwZnRIwDQYJKoZIhvcNAQELBQAwgb0xCzAJBgNVBAYT
# AlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24g
# VHJ1c3QgTmV0d29yazE6MDgGA1UECxMxKGMpIDIwMDggVmVyaVNpZ24sIEluYy4g
# LSBGb3IgYXV0aG9yaXplZCB1c2Ugb25seTE4MDYGA1UEAxMvVmVyaVNpZ24gVW5p
# dmVyc2FsIFJvb3QgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMTEyMDAw
# MDAwWhcNMzEwMTExMjM1OTU5WjB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3lt
# YW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdv
# cmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7WZ1ZVU+djHJdGoGi61XzsAGt
# PHGsMo8Fa4aaJwAyl2pNyWQUSym7wtkpuS7sY7Phzz8LVpD4Yht+66YH4t5/Xm1A
# ONSRBudBfHkcy8utG7/YlZHz8O5s+K2WOS5/wSe4eDnFhKXt7a+Hjs6Nx23q0pi1
# Oh8eOZ3D9Jqo9IThxNF8ccYGKbQ/5IMNJsN7CD5N+Qq3M0n/yjvU9bKbS+GImRr1
# wOkzFNbfx4Dbke7+vJJXcnf0zajM/gn1kze+lYhqxdz0sUvUzugJkV+1hHk1inis
# GTKPI8EyQRtZDqk+scz51ivvt9jk1R1tETqS9pPJnONI7rtTDtQ2l4Z4xaE3AgMB
# AAGjggF3MIIBczAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADBm
# BgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8v
# ZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8vZC5zeW1jYi5j
# b20vcnBhMC4GCCsGAQUFBwEBBCIwIDAeBggrBgEFBQcwAYYSaHR0cDovL3Muc3lt
# Y2QuY29tMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9zLnN5bWNiLmNvbS91bml2
# ZXJzYWwtcm9vdC5jcmwwEwYDVR0lBAwwCgYIKwYBBQUHAwgwKAYDVR0RBCEwH6Qd
# MBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4LTMwHQYDVR0OBBYEFK9j1sqjToVy
# 4Ke8QfMpojh/gHViMB8GA1UdIwQYMBaAFLZ3+mlIR59TEtXC6gcydgfRlwcZMA0G
# CSqGSIb3DQEBCwUAA4IBAQB16rAt1TQZXDJF/g7h1E+meMFv1+rd3E/zociBiPen
# jxXmQCmt5l30otlWZIRxMCrdHmEXZiBWBpgZjV1x8viXvAn9HJFHyeLojQP7zJAv
# 1gpsTjPs1rSTyEyQY0g5QCHE3dZuiZg8tZiX6KkGtwnJj1NXQZAv4R5NTtzKEHhs
# Qm7wtsX4YVxS9U72a433Snq+8839A9fZ9gOoD+NT9wp17MZ1LqpmhQSZt/gGV+HG
# Dvbor9rsmxgfqrnjOgC/zoqUywHbnsc4uw9Sq9HjlANgCk2g/idtFDL8P5dA4b+Z
# idvkORS92uTTw+orWrOVWFUEfcea7CMDjYUq0v+uqWGBMIIFSzCCBDOgAwIBAgIQ
# e9Tlr7rMBz+hASMEIkFNEjANBgkqhkiG9w0BAQsFADB3MQswCQYDVQQGEwJVUzEd
# MBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVj
# IFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3Rh
# bXBpbmcgQ0EwHhcNMTcxMjIzMDAwMDAwWhcNMjkwMzIyMjM1OTU5WjCBgDELMAkG
# A1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQL
# ExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMTEwLwYDVQQDEyhTeW1hbnRlYyBTSEEy
# NTYgVGltZVN0YW1waW5nIFNpZ25lciAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOC
# AQ8AMIIBCgKCAQEArw6Kqvjcv2l7VBdxRwm9jTyB+HQVd2eQnP3eTgKeS3b25TY+
# ZdUkIG0w+d0dg+k/J0ozTm0WiuSNQI0iqr6nCxvSB7Y8tRokKPgbclE9yAmIJgg6
# +fpDI3VHcAyzX1uPCB1ySFdlTa8CPED39N0yOJM/5Sym81kjy4DeE035EMmqChhs
# VWFX0fECLMS1q/JsI9KfDQ8ZbK2FYmn9ToXBilIxq1vYyXRS41dsIr9Vf2/KBqs/
# SrcidmXs7DbylpWBJiz9u5iqATjTryVAmwlT8ClXhVhe6oVIQSGH5d600yaye0BT
# WHmOUjEGTZQDRcTOPAPstwDyOiLFtG/l77CKmwIDAQABo4IBxzCCAcMwDAYDVR0T
# AQH/BAIwADBmBgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEW
# F2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8v
# ZC5zeW1jYi5jb20vcnBhMEAGA1UdHwQ5MDcwNaAzoDGGL2h0dHA6Ly90cy1jcmwu
# d3Muc3ltYW50ZWMuY29tL3NoYTI1Ni10c3MtY2EuY3JsMBYGA1UdJQEB/wQMMAoG
# CCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIHgDB3BggrBgEFBQcBAQRrMGkwKgYIKwYB
# BQUHMAGGHmh0dHA6Ly90cy1vY3NwLndzLnN5bWFudGVjLmNvbTA7BggrBgEFBQcw
# AoYvaHR0cDovL3RzLWFpYS53cy5zeW1hbnRlYy5jb20vc2hhMjU2LXRzcy1jYS5j
# ZXIwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4LTYwHQYD
# VR0OBBYEFKUTAamfhcwbbhYeXzsxqnk2AHsdMB8GA1UdIwQYMBaAFK9j1sqjToVy
# 4Ke8QfMpojh/gHViMA0GCSqGSIb3DQEBCwUAA4IBAQBGnq/wuKJfoplIz6gnSyHN
# srmmcnBjL+NVKXs5Rk7nfmUGWIu8V4qSDQjYELo2JPoKe/s702K/SpQV5oLbilRt
# /yj+Z89xP+YzCdmiWRD0Hkr+Zcze1GvjUil1AEorpczLm+ipTfe0F1mSQcO3P4bm
# 9sB/RDxGXBda46Q71Wkm1SF94YBnfmKst04uFZrlnCOvWxHqcalB+Q15OKmhDc+0
# sdo+mnrHIsV0zd9HCYbE/JElshuW6YUI6N3qdGBuYKVWeg3IRFjc5vlIFJ7lv94A
# vXexmBRyFCTfxxEsHwA/w0sUxmcczB4Go5BfXFSLPuMzW4IPxbeGAk5xn+lmRT92
# MYICWjCCAlYCAQEwgYswdzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVj
# IENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMSgw
# JgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIENBAhB71OWvuswH
# P6EBIwQiQU0SMAsGCWCGSAFlAwQCAaCBpDAaBgkqhkiG9w0BCQMxDQYLKoZIhvcN
# AQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIxMDkwMjExNTQ0MFowLwYJKoZIhvcNAQkE
# MSIEIBuHNMpcG9gCWR6+3pl/79SEhquoAs4soc3MkGLJkUuUMDcGCyqGSIb3DQEJ
# EAIvMSgwJjAkMCIEIMR0znYAfQI5Tg2l5N58FMaA+eKCATz+9lPvXbcf32H4MAsG
# CSqGSIb3DQEBAQSCAQCIkOpUKTYDrlocAUBq4gHTi/iBN6sffdoaJWK97dqlXpj7
# lTXcKyw4Pm7MxmZIe/Ofj+69oOhpwCGg7B+KJR8YOI2Q0/lLC1fmfDrGITcL11yl
# xSHgta7GlJfh8HDCb/QWU9VUe346xpmtTsyM8ivONBGAHyJC2OKXDvANWlaOcP3N
# fR11BUl71Dt2qvLML2QopzLLsu8Pr7iWccxbZ/64TxkUqG86cHsATTPJO/F+ZAyl
# JKdUUOpm0KWrjjLu7qbjfWSesxnRFoUyI9PvSlaAThFHM0d/6Omuut/4NY3YbO5C
# 9edV/FrmZjdcFWvn2krgkWv1L8LAMLJTsRCoQJMi
# SIG # End signature block
