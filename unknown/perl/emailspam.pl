#!/usr/bin/perl

use Mail::Sendmail;

for $i (1..100) {
	%mail = (
	    Smtp => 'mail.internode.on.net',
	    To => 'Nigger <yonhyaro@gmail.com>',
        Bcc => 'Me <anacrolix@gmail.com>',
	    From => 'Your Mum <mum@matts.bed.com>',
	    Subject => "H4h4 fv<k3d !n th3 \@ss #$i",
        Message => "kraut fucker! :)\n\nFrom your loving Mother.",
        Date => Mail::Sendmail::time_to_date($i*365.25*24*3600)
	    );
	sendmail(%mail) or die $Mail::Sendmail::error;
    print "Sent message $i\n";
}
print "OK. Log says:\n", $Mail::Sendmail::log;
