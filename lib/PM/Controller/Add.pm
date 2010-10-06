package PM::Controller::Add;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $body = $view->render_with_encode('add.tx', {});
    return [200, ['Content-Type' => 'text/html'], [$body]];
}

sub post {
    my $self = shift;
    my $env  = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $req = Plack::Request->new($env);
    my $url = $req->param('url');

    if ($url =~ /([s|n]m\d+)/) {
        return PM::Controller::HTTPError->code_301("/add/$1");

    } else {
        return PM::Controller::HTTPError->code_301("/add");
    }
}

1;
__END__

