package PM::Model::Login::Callback;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model::Login';

use Try::Tiny;
use PM::Model::Login;
use OAuth::Lite::Consumer;

my $model = PM::Model->new;

sub fetch_verify_credentials {
    my $self = shift;
    my $env  = shift;

    my $req = Plack::Request->new($env);
    my $p   = $req->parameters;

    if ($p->{denied} || !$p->{oauth_token} || !$p->{oauth_verifier}) {
        return 0;
    }

    my $oauth = PM::Model::Login->load_oauth_token;

    my $consumer = OAuth::Lite::Consumer->new(%$oauth);
    my $token = $consumer->get_access_token(
        token    => $p->{oauth_token},
        verifier => $p->{oauth_verifier},
    );

    my $verify_res = $consumer->request( method => 'GET',
        url => 'http://twitter.com/account/verify_credentials.json',
        token => $token,
    );

    unless ($verify_res->is_success) {
        return 0;
    }

    return JSON::decode_json($verify_res->decoded_content);
}

sub create_user {
    my $self = shift;
    my $credentials = shift;

    my $result = 1;
    try {
        my $sth = $model->dbh->prepare(q{
            INSERT INTO users (uid, created_at)
                 VALUES (?, ?)
        });
        $sth->execute($credentials->{id}, time);

    } catch {
        unless (/Duplicate entry/) {
            warn $_;
            $result = 0;
        }
    };

    return $result;
}

1;
__END__

