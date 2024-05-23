import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "52",
    countryCode: "MX",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name:  "Mexico",
    example: "Mexico",
    displayName: "Mexico",
    displayNameNoCountryCode: "Mexico",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length
      )
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            // make scrollable content 
            child: SingleChildScrollView(
              child: Column(
              children: [
                Image.asset('assets/registration-removebg.png', width: double.infinity),
                const SizedBox(height: 20.0),
                const Text(
                  'Regístrate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Añade tu número de teléfono. Te enviaremos un código de verificación vía SMS.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                  ),
                ),

                const SizedBox(height: 20.0),
                TextFormField(
                  controller: phoneController,
                  onChanged:(value) => setState(() {phoneController.text = value;}),
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Número de teléfono',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            countryListTheme: CountryListThemeData(
                              flagSize: 30.0,
                              bottomSheetHeight: 450.0,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountry = country;
                              });
                            }
                          );
                        },
                        child: Text(
                          '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          )
                        )
                      )
                    ),
                    suffixIcon: phoneController.text.length > 9 ?
                    Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 20.0
                      )
                    ) : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                // custom button
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Enviar código de validación',
                    onPressed: () => sendPhoneNumber(),
                    isDisabled: phoneController.text.length < 10
                  )
                ),
              ]
            )
          )
          )
        ),
      )
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}