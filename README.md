Windows_Certs
--
[![Build Status](https://travis-ci.org/cyberious/windows_certs.png?branch=master)](https://travis-ci.org/cyberious/windows_certs)

Usage
---
By Default it will both ensure that the file from the source_location is present and that the cert is installed in the location.

Please note that if you have installed the cert previously in a different location it will not be able to install it.

The friendly name of the cert is required as well as a secure string which can be obtained from PowerShell using the following command,
simply copy the output or pipe to a file that you would like to save for later.

        Read-Host -AsSecureString -Prompt Password | ConvertFrom-SecureString -Key @(1..32)


Examples
---
       windows_certs::pfx{"My Certs Friendly Name":
                cert_stage_location           => "c:\\stage\\this.domain.pfx",
                secure_string_password  => $certPass,
                source_location         => "puppet:///extra_files/this.domain.pfx"
       }

       windows_certs::pfx{"My Certs Friendly Name":
                       cert_location           => "c:\\stage\\myRoot.domain.pfx",
                       secure_string_password  => $certPass,
                       cert_store               => "Root",
                       source_location         => "puppet:///extra_files/myRoot.domain.pfx"
       }


Future plans
---
Force Cert removal if not in the specified location

Provide backwards compatibility to windows 2008 and higher currently only 2012 and higher
