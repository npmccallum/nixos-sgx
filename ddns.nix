{ config, pkgs, ... }:

{
  systemd.timers.ddns = {
    enable = true;
    timerConfig.OnCalendar = "*:0/5";
    wantedBy = [ "timer.target" "multi-user.target" ];
  };

  systemd.services.ddns = {
    serviceConfig.Type = "oneshot";
    path = with pkgs; [ curl ];
    script = ''
      while read name domain hash; do
	url="http://ddns.corp.redhat.com/redhat-ddns/updater.php?name=$name&domain=$domain&hash=$hash"
	rep=$(curl -s "$url")
	! echo $rep | grep ERROR
      done < /etc/ddns.conf
    '';
  };
}
