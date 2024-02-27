import 'package:auth_migration/shared/components/styles.dart';
import 'package:flutter/material.dart';


class ButtonAcaoWidget extends StatelessWidget {
  final Function? detalhe;
  final Function? deletar;
  final Function? editar;
  final Function? qrCode;
  final Function? transferencia;

  const ButtonAcaoWidget({
    Key? key,
    this.detalhe,
    this.deletar,
    this.editar,
    this.qrCode,
    this.transferencia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          transferencia != null
              ? GestureDetector(
                  onTap: () {
                    transferencia!();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.sync_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : Container(),
          qrCode != null
              ? GestureDetector(
                  onTap: () {
                    qrCode!();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.qr_code_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : Container(),
          detalhe != null
              ? GestureDetector(
                  onTap: () {
                    detalhe!();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.visibility_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : Container(),
          editar != null
              ? GestureDetector(
                  onTap: () {
                    editar!();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : Container(),
          deletar != null
              ? GestureDetector(
                  onTap: () => deletar!(),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              : Container(),
        ]);
  }
}
