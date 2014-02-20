define windows_certs::pfx ($cert_name = $title,$cert_stage_location,$cert_secure_pass,$cert_store = "WebHosting",$source_location){

  validate_string($cert_name)
  validate_string($cert_secure_pass)
  validate_absolute_path($cert_stage_location)
  #validate_ext($cert_stage_location,'pfx')

  if $operatingsystem != "windows" {
    fail("Only capable with Windows Systems")
  }

  file{$cert_stage_location:
      source  => $source_location,
      ensure  => file
  }
  if($::kernelmajversion == "6.2"){
    $cmd = "Import-Module WebAdministration; Import-PfxCertificate -FilePath ${$cert_stage_location} -CertStoreLocation Cert:\\LocalMachine\\${cert_store} -Password (\"${$cert_secure_pass}\" | ConvertTo-SecureString -Key @(1..32))"
    $checkCmd = "Import-Module WebAdministration; if (gci cert:\LocalMachine\${cert_store} -R | where FriendlyName -eq \"${cert_name}\") { exit 1 } else { exit 0 }"

  }else{

  }
  exec{"Insert-PFX-Cert-${cert_name}":
      command   => $cmd,
      onlyif    => $checkCmd,
      provider  => powershell,
      require   => File[$cert_stage_location]
  }
}
