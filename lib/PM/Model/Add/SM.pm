package PM::Model::Add::SM;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model::Add';

use Encode;
use Data::Dumper;
use Digest::MD5;
use JSON::XS;
use XML::Simple;
use LWP::UserAgent;
use Try::Tiny;
use Unicode::Normalize qw/NFKC/;

use PM::Model::Cache;

my $cache = PM::Model::Cache->new;
my $model = PM::Model->new;

sub prefix { 'PM:Cache:mylist:' }

sub add {
    my $self = shift;
    my $sm   = shift;
    my $uid  = shift;
    my $tag  = shift;

    my $hash = Digest::MD5::md5_hex($uid . $sm . $tag);

    try {
        my $sth = $model->dbh->prepare(q{
            INSERT INTO usertags (uid, vid, tag, md5)
                 VALUES (?, ?, ?, ?)
        });
        $sth->execute($uid, $sm, $tag, $hash);

    } catch {
        warn $_ unless ($_ =~ /Duplicate entry/);

    };

}

sub exists {
    my $self = shift;
    my $sm   = shift;
    my $uid  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT tag
          FROM usertags
         WHERE (uid = ?)
           AND (vid = ?)
    });
    $sth->execute($uid, $sm);

    my @tags;
    for my $item ( @{ $sth->fetchall_arrayref } ) {
        push @tags, Encode::decode_utf8($item->[0]);
    }

    return \@tags;
}

sub fetch_video_info {
    my $self = shift;
    my $sm   = shift;

    if (my $value = $self->from_cache($sm)) {
        return $value;

    } elsif (my $value = $self->from_api($sm)) {
        $self->to_db($sm, $value);
        $self->to_cache($sm, $value);
        return $value;

    } else {
        return undef;
    }
}

sub to_db {
    my $self = shift;
    my $sm   = shift;
    my $thumbinfo = shift;

    try {
        my $sth = $model->dbh->prepare(q{
            INSERT INTO vinfo (vid, title)
                 VALUES (?, ?)
        });
        $sth->execute($sm, $thumbinfo->{title});

    } catch {
        warn $_ unless /Duplicate entry/;

    };

}

sub to_cache {
    my $self = shift;
    my $sm   = shift;
    my $thumbinfo = shift;

    $cache->rdb->put($self->prefix . $sm, JSON::XS::encode_json($thumbinfo))
        or warn $cache->rdb->errmsg($cache->rdb->ecode);
}

sub from_cache {
    my $self = shift;
    my $sm   = shift;

    my $rv = undef;
    try {
        $rv = JSON::XS::decode_json($cache->rdb->get($self->prefix . $sm));
    };

    return $rv;
}

sub from_api {
    my $self = shift;
    my $sm   = shift;

    my $api = "http://ext.nicovideo.jp/api/getthumbinfo/$sm";

    my $ua = LWP::UserAgent->new;
    my $xml = XML::Simple::XMLin($ua->get($api)->content,
        ForceArray => [qr/^tags$/, qr/^tag$/]);

    if ($xml->{status} ne 'ok') {
        return undef;
    }

    my @tags;
    for my $tag (@{ $xml->{thumb}{tags} }) {
        if ($tag->{domain} eq 'jp') {
            for my $item (@{ $tag->{tag} }) {
                if (defined $item->{content}) {
                    push @tags, $item->{content}
                } else {
                    push @tags, $item;
                }
            }
        }
    }

    for (@tags) {
        $_ = NFKC $_;
    }

    my $thumbinfo = {
        title => $xml->{thumb}{title},
        vid   => $xml->{thumb}{video_id},
        tags  => \@tags,
    };

    return $thumbinfo;
}

1;
__END__

