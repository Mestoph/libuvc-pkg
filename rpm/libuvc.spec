Name:           libuvc
Version:        0.0.6
Release:        1
Summary:        Userspace UVC driver library
License:        BSD-2-clause
URL:            https://github.com/ktossell/libuvc
Prefix:         %{_prefix}
Provides:       libuvc = %{version}-%{release}
Obsoletes:      libuvc <= 0.0.4
Requires:       libusbx
BuildRequires:  gcc
BuildRequires:  libusbx-devel
BuildRequires:  cmake
BuildRequires:  gcc-c++
BuildRequires:  libstdc++-devel
Source:         libuvc-%{version}.tar.gz

%description
libuvc is a user-space driver library for UVC cameras.  It also supports
some UVC-like cameras including some of those produced by The Imaging
Source.

%package        devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}
Provides:       libuvc-devel = %{version}-%{release}
Obsoletes:      libuvc-devel <= 0.0.4

%description    devel
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.

%prep
%setup -q

%build
%cmake . -DCMAKE_INSTALL_LIBDIR=/usr/lib64
make %{?_smp_mflags}

%install
make install DESTDIR=%{buildroot} CMAKE_INSTALL_LIBDIR=/usr/lib64
mkdir -p %{buildroot}%{_libdir}/cmake
mv %{buildroot}/usr/lib/%{name}.so %{buildroot}%{_libdir}/%{name}.so.%{version}
ln -sf %{name}.so.%{version} %{buildroot}%{_libdir}/%{name}.so.0
mv %{buildroot}/usr/lib/%{name}.a %{buildroot}%{_libdir}/
mv %{buildroot}/usr/lib/cmake/* %{buildroot}%{_libdir}/cmake/
sed -i '/libdir=/s!=.*$!=%{_libdir}!' %{buildroot}%{_libdir}/pkgconfig/libuvc.pc

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig


%files
%{_libdir}/*.so.*

%files devel
%{_includedir}/libuvc/*
%{_libdir}/pkgconfig/libuvc.pc
%{_libdir}/cmake/libuvc/*
%{_libdir}/*.a

%changelog
* Tue Nov 15 2016 James Fidell <james@openastroproject.org> - 0.0.6-1
- Initial RPM release

