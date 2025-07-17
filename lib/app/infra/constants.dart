class Constants {
	Constants._();

	static const String appName =	'Sistema Financeiro Pessoal';
	static const String appVersion =	'1.0.1';
	
	static const double flutterBootstrapGutterSize = 10.0;
	static const int gridRowsPerPage = 10;

	static const String imageDir = 'assets/images';
	static const String dialogQuestionIcon = '$imageDir/dialog-question-icon.png';
	static const String dialogInfoIcon = '$imageDir/dialog-info-icon.png';
	static const String dialogErrorIcon = '$imageDir/dialog-error-icon.png';	
	static const String logotipo = '$imageDir/logotipo.png';
	static const String backgroundImage = '$imageDir/background.png';
	static const String loginImage = '$imageDir/login.jpg';
	static const String profileImage = '$imageDir/profile.png';

	// local database
	static const bool usingLocalDatabase = true;
	static const sqlGetSettings = "SELECT * FROM HIDDEN_SETTINGS WHERE ID=1";

	// server
	static String sentryDns = '';
	static String serverAddress = 'http://localhost';
	static String serverAddressComplement = '/financeiro_pessoal';
	static String serverPort = '80';		

  // mobile
  static const bool enableMobileLayout = true;	
}

const ufList = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'];

enum DialogType {
	info,
	warning,
	error,
	success,
	question,
	noHeader
}