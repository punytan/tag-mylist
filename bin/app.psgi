use practical;
use lib 'lib';
use File::Spec;

use PM;
use PM::Plack;
use Lanky;

use Plack::Builder;

my $lanky = Lanky->new(
    application => [
        '/'           => 'PM::Controller::Root',
        '/tag'        => 'PM::Controller::Tag',
        '/tag/(.+)'   => 'PM::Controller::Tag::Show',
        '/mytag'      => 'PM::Controller::Mytag',
        '/mytag/(.+)' => 'PM::Controller::Mytag::Show',
        '/add'        => 'PM::Controller::Add',
        '/add/([s|n]m\d+)'    => 'PM::Controller::Add::SM',
        '/delete/([s|n]m\d+)' => 'PM::Controller::Delete',
        '/logout'     => 'PM::Controller::Logout',
        '/login'      => 'PM::Controller::Login',
        '/login/callback' => 'PM::Controller::Login::Callback',
    ],
    template => [
        path => ['templates'],
        cache_dir => File::Spec->tmpdir,
    ],
    errordoc_path => 'errordoc',
    render_encoding => 'utf8',
);

builder {
    enable 'Lint';

    enable 'Session',
        store => Plack::Session::Store::TokyoTyrant->new(
            server     => ['localhost', 1978],
            key_prefix => 'PM:Session:',
        ),
        state => Plack::Session::State::Cookie->new(
            expires => 1 * 60 * 60 * 24 * 60,
            domain  => 'mylist.linknode.net',
            session_key => 'user_session',
        );

    $lanky->to_app;

};

__END__

