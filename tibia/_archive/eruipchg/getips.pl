#!/usr/bin/perl -w

foreach (1..5) {
  foreach (sprintf("login0%d.tibia.com", $_),
	   sprintf("server0%d.cipsoft.com", $_)) {
    print `host $_`;
  }
}
