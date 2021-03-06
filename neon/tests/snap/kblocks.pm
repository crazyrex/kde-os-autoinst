# Copyright (C) 2018 Harald Sitter <sitter@kde.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License or (at your option) version 3 or any later version
# accepted by the membership of KDE e.V. (or its successor approved
# by the membership of KDE e.V.), which shall act as a proxy
# defined in Section 14 of version 3 of the license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use base "basetest_neon";
use strict;
use testapi;

sub run {
    my ($self) = @_;

    $self->boot;
    $self->enable_snapd_and_install_snap;

    x11_start_program 'konsole';
    assert_screen 'konsole';
    type_string '/snap/bin/kblocks';
    send_key 'ret';

    assert_and_click 'kblocks-single';
    assert_screen 'kblocks-single-running';
    assert_and_click 'kblocks-quit';

    send_key 'alt-f4'; # close konsole again
}

1;
