use strict;
use warnings;

use DDP;
use XML::RSS;
use JSON::XS;
use REST::Client;

# API url of the account
my $GAB = $ARGV[0];
# Output location, default .
my $XML = $ARGV[1] || 'out.xml';

my $client = REST::Client->new();
my $json   = decode_json($client->GET($GAB)->responseContent());

my $rss = XML::RSS->new(version => '1.0');
$rss->channel(
    title       => 'Title',
    link        => $GAB,
    description => 'Description'
);

foreach my $post ($json->@*) {
    my $content = $post->{content} ne ''
        ? $post->{content}
        : $post->{reblog}->{content};

    $rss->add_item(
        title       => substr($content, 0, 40) . '...',
        link        => $post->{url},
        description => $content
    );
}

$rss->save($XML);
