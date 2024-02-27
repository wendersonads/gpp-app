import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators, AbstractControl } from '@angular/forms';
import { FornecedorModel } from 'src/app/models/FornecedorModel';
import { FornecedorService } from '../../services/fornecedor.service';
import { ActivatedRoute, Router } from '@angular/router';
import { ConfirmationService, MessageService, ConfirmEventType } from 'primeng/api';
import { LocalDataSource } from 'ng2-smart-table';


function lettersOnly(control: AbstractControl): { [key: string]: any } | null {
  const lettersPattern = /^[A-Za-z]+$/;
  const value = control.value;
  if (!lettersPattern.test(value.replace(/\s/g, '')) || value.length < 4) {
    return { lettersOnly: true };
  }
  return null;
}

@Component({
  selector: 'app-fornecedor-form',
  templateUrl: './fornecedor-form.component.html',
  styleUrls: ['./fornecedor-form.component.css'],
  providers: [ConfirmationService, MessageService]

})
export class FornecedorFormComponent implements OnInit {
  displayDialog = true;
  fornecedorForm: FormGroup;
  pageTitle: string = 'Fornecedor';
  fornecedores: FornecedorModel[] = [];
  source: LocalDataSource = new LocalDataSource(this.fornecedores);


  constructor(
    private fornecedorService: FornecedorService,
    private router: Router,
    private route: ActivatedRoute,
    private formBuilder: FormBuilder,
    private confirmationService: ConfirmationService,
    private messageService: MessageService
  ) {
    this.fornecedorForm = this.formBuilder.group({});
  }

  ngOnInit(): void {
    this.buildForm();
    this.list();
  }

  fornecedor: FornecedorModel = {
    nomeFornecedor: '',
    email: '',
    cnpj: ''
  };

  list(): void {
    this.fornecedorService.list().subscribe(resp => {
      this.fornecedores = resp;
    });
  }


  salvar(): void {
    // if (this.fornecedorForm.invalid) {
    //   return;
    // }

    this.fornecedor = { ...this.fornecedor, ...this.fornecedorForm.value };

    this.fornecedorService.add(this.fornecedor).subscribe({

      error: (error: any) => {
        if (error.status === 400 || error.status === 500 || error.status === 404) {
          const errorMessage = error?.error?.message || 'Erro desconhecido';
          console.log(errorMessage);

          this.messageService.add({ severity: 'error', detail: errorMessage });

        } else {
          this.messageService.add({ severity: 'success', detail: 'Cadastro Realizado!' });
          this.list();
          this.fornecedor = new FornecedorModel();
          this.fornecedorForm.patchValue({
            nomeFornecedor: '',
            email: '',
            cnpj: ''
          });
        }
      }
    });

  }

  cancelar(): void {
    this.router.navigateByUrl(`fornecedorList`);

  }

  loadProduto(fornecedor: FornecedorModel): void {
    this.fornecedorService.get(fornecedor.idFornecedor!).subscribe(fornecedor => {
      this.fornecedor = fornecedor;

      // Update form values with loaded product data
      this.fornecedorForm.patchValue({
        nomeFornecedor: fornecedor.nomeFornecedor,
        email: fornecedor.email,
        cnpj: fornecedor.cnpj
      });
    });
  }

  editeFornecedor(fornecedor: FornecedorModel): void {

    this.loadProduto(fornecedor);

  }

  deleteFornecedor(id: number): void {


  }

  onDialogHide(): void {
    this.cancelar();
  }

  private buildForm(): void {
    this.fornecedorForm = this.formBuilder.group({
      nomeFornecedor: ['', [Validators.required, lettersOnly]],
      email: ['', [Validators.required, lettersOnly]],
      cnpj: ['', [Validators.required, lettersOnly]]
    });
  }
}
