Summary: A PDF file viewer for the X Window System
Name: xpdf-pr
Version: 3.04
Release: 14%{?dist}
License: GPLv2 or GPLv3
Epoch: 1
Url: https://github.com/PolicyReporter/xpdf-pr
Group: Applications/Publishing

Source0: xpdf-pr.tar.gz

Requires: libpng

BuildRequires: openmotif-devel
BuildRequires: freetype-devel >= 2.1.7
BuildRequires: libpng-devel

Obsoletes: xpdf 
Obsoletes: poppler

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Policy Reporter fork of xpdf with integrated pdftohtml.
Xpdf is an X Window System based viewer for Portable Document Format
(PDF) files. Xpdf is a small and efficient program which uses
standard X fonts.

%prep
%setup -n %{name}

%build
find -name "*orig" | xargs rm -f

%configure \
   --with-freetype2-library=%{_libdir} \
   --with-freetype2-includes=%{_includedir}/freetype2

make %{?_smp_mflags}

%install
mkdir -p $RPM_BUILD_ROOT%{_datadir}/xpdf

make
make install DESTDIR=$RPM_BUILD_ROOT

# xpdfrc cleanup
sed -i -e 's:/usr/local/share/:%{_datadir}/:g' $RPM_BUILD_ROOT%{_sysconfdir}/xpdfrc

%files
%{_bindir}/*
%{_mandir}/man?/*
%config(noreplace) %verify(not md5 size mtime) %{_sysconfdir}/xpdfrc
