use Mail::Sendmail;

%mail = (Message => "This is a test message.",
	 Subject => "Test",
	 To => 'AussieHQ <alerts@aussiehq.com.au>',
	 From => 'ServaMon <servamon@eruanno.com>',
	 );

sendmail(%mail) or die $Mail::Sendmail::error;

print "OK. Log says:\n", $Mail::sendmail::log;
