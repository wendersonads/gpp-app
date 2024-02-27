import { Component, OnInit } from '@angular/core';
import { FornecedorModel } from 'src/app/models/FornecedorModel';
import { FornecedorService } from '../../services/fornecedor.service';
import { ActivatedRoute, Router } from '@angular/router';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MessageService } from 'primeng/api';

function lettersOnly(control: AbstractControl): { [key: string]: any } | null {
  const lettersPattern = /^[A-Za-z]+$/;
  const value = control.value;
  if (!lettersPattern.test(value.replace(/\s/g, '')) || value.length < 4) {
    return { lettersOnly: true };
  }
  return null;
}

@Component({
  selector: 'app-fornecedor-form-edit',
  templateUrl: './fornecedor-form-edit.component.html',
  styleUrls: ['./fornecedor-form-edit.component.css']
})
export class FornecedorFormEditComponent implements OnInit {


  displayDialog: boolean = true; // add this line
  pageTitle: string = 'Edição';
  fornecedorForm!: FormGroup; // Add "!" to indicate that it will be initialized in the constructor
  fornecedor: FornecedorModel = new FornecedorModel();

  ngOnInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.fornecedorForm.get('cnpj')?.disable();

     
    this.fornecedorService.get(id).subscribe(forne => {
      this.fornecedor = forne;
      this.fornecedorForm.patchValue(this.fornecedor);

      console.log(forne);

    });
  }

  constructor(private fornecedorService: FornecedorService,
    private router: Router,
    private route: ActivatedRoute,
    private formBuilder: FormBuilder,
    private messageService: MessageService
  ) {
    this.buildForm(); // Call the buildForm method to initialize the pecaForm
  }


  onRefresh(fornecedor: FornecedorModel): void {




  }

  public editar() {
    // if (this.fornecedorForm?.invalid) {
    //   return;
    // }

    this.fornecedor = { ...this.fornecedor, ...this.fornecedorForm?.value };

    this.fornecedorService.put(this.fornecedor).subscribe({

      error: (error: any) => {
        if (error.status === 400 || error.status === 500 || error.status === 404) {
          const errorMessage = error?.error?.message || 'Erro desconhecido';
          console.log(errorMessage);

          this.messageService.add({ severity: 'error', detail: errorMessage });

        } else {
          this.messageService.add({ severity: 'success', detail: 'Cadastro Realizado!' });
          this.fornecedor = new FornecedorModel();
          this.router.navigateByUrl('/fornecedorList');
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
    this.router.navigateByUrl('/fornecedorList');
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