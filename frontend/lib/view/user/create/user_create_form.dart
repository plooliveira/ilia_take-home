import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/utils/validators.dart';
import 'package:frontend/shared/widgets/app_toast.dart';
import 'package:frontend/shared/widgets/custom_text_field.dart';
import 'package:frontend/shared/widgets/primary_button.dart';
import 'package:frontend/view/user/create/user_form_controller.dart';

class UserForm extends CtrlWidget<UserFormCtrl> {
  const UserForm({super.key, this.onUserCreated});

  final VoidCallback? onUserCreated;

  @override
  void onInit(BuildContext context, ctrl) {
    ctrl.onUserCreated = onUserCreated;
    ctrl.onUserCreationError = (String error) =>
        onUserCreationError(context, error);
    super.onInit(context, ctrl);
  }

  void onUserCreationError(BuildContext context, String error) {
    AppToast.show(
      context,
      error,
      position: ToastPosition.top,
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context, ctrl) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: ctrl.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Novo Usuário',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: ctrl.nameController,
                  labelText: 'Nome completo',
                  prefixIcon: const Icon(Icons.person_outline),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: AppValidators.combine([
                    // Comment to test the error message coming from the backend
                    AppValidators.required('Nome é obrigatório'),
                  ]),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: ctrl.emailController,
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: AppValidators.combine([
                    // Comment to test the error message coming from the backend
                    AppValidators.required('E-mail é obrigatório'),
                    AppValidators.email('E-mail inválido'),
                  ]),
                ),
                const SizedBox(height: 24),
                Watch(
                  ctrl.isLoading,
                  builder: (context, isLoading) => PrimaryButton(
                    text: 'Salvar',
                    isLoading: isLoading,
                    onPressed: () => ctrl.createUser(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
