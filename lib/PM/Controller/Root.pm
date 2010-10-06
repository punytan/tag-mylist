package PM::Controller::Root;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use PM::Model::Root;
use PM::Model::Session;

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;

    if (PM::Model::Session->is_login($env)) {

        my @rows = PM::Model::Root->fetch_random_vid;

        my %vinfo;
        for my $row (@rows) {
            my $value = PM::Model::Root->fetch_video_info($row);
            $vinfo{$row} = $value;
            if ($row =~ /[s|n]m(\d+)/) {
                $vinfo{$row}->{thumbid} = $1;
            } else {
                #$vinfo{$row}{thumbid} = $row;
            }
        }

        my $body = $view->render_with_encode('root_login.tx', {
            session => $env->{'psgix.session'}, random => \%vinfo});

        return [200, ['Content-Type' => 'text/html'], [$body]];
        
    } else {
        my $body = $view->render_with_encode('root_not_login.tx', {});

        return [200, ['Content-Type' => 'text/html'], [$body]];
    }
}

1;
__END__

