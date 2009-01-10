import tibiacom

current = tibiacom.online_list("Dolera")
for a in current:
	tibiacom.pretty_print_char_info(tibiacom.char_info(a["name"]))
	print
