package PM::Controller::Root;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use PM::Model::Session;

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;

    if (PM::Model::Session->is_login($env)) {
        my $body = $view->render_with_encode('root_login.tx', {
            session => $env->{'psgix.session'}});

        return [200, ['Content-Type' => 'text/html'], [$body]];
        
    } else {
        my $body = $view->render_with_encode('root_not_login.tx', {});

        return [200, ['Content-Type' => 'text/html'], [$body]];
    }
}

1;
__END__

