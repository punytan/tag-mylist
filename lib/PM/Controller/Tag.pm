package PM::Controller::Tag;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use PM::Model::Tag;
use YAML;

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $tags = PM::Model::Tag->fetch_mytags(
        $env->{'psgix.session'}{id});

    my $body = $view->render_with_encode('tag_root.tx', {
        tags => $tags});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

1;
__END__

