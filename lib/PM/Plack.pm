use PM::Plack;
use common::sense;
our $VERSION = '0.01';

use Plack;
use Plack::Middleware::Session;
use Plack::Session::State::Cookie;
use Plack::Session::Store::TokyoTyrant;

1;
__END__

