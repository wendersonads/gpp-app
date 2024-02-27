import { Component, OnInit } from '@angular/core';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { ProdutoService } from '../../services/produto.service';
import { ActivatedRoute, Router } from '@angular/router';
import { FornecedorModel } from 'src/app/models/FornecedorModel';
import { FornecedorService } from '../../services/fornecedor.service';
import { SelectItem } from 'primeng/api';
import { Message, MessageService } from 'primeng/api';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';

function lettersOnly(control: AbstractControl): { [key: string]: any } | null {
  const lettersPattern = /^[A-Za-z]+$/;
  let value = control.value;

  if (value == null || value === '') {
    return null; // Skip validation if the value is null or empty
  }

  if (typeof value !== 'string') {
    value = value.toString(); // Convert to string if value is not already a string
  }

  if (!lettersPattern.test(value.replace(/\s/g, '')) || value.length < 4) {
    return { lettersOnly: true };
  }
  
  return null;
}

@Component({
  selector: 'app-produto-form',
  templateUrl: './produto-form.component.html',
  styleUrls: ['./produto-form.component.css']
})
export class ProdutoFormComponent implements OnInit {
  displayDialog: boolean = true;
  fornecedors: FornecedorModel[] = [];
  filteredFornecedors: FornecedorModel[] = [];
  msgs: Message[] = [];
  pageTitle: string = 'Produto';
  produtoForm: FormGroup;
  filteredFornecedores: FornecedorModel[] = [];
  selectedFornecedor: FornecedorModel | null = null;

  ngOnInit(): void {
    this.buildForm();

    this.fornecedorService.list().subscribe(fornecedors => {
      this.fornecedors = fornecedors;
    });
  }

  constructor(
    private produtoService: ProdutoService,
    private router: Router,
    private route: ActivatedRoute,
    private fornecedorService: FornecedorService,
    private messageService: MessageService,
    private formBuilder: FormBuilder
  ) {
    this.produtoForm = this.formBuilder.group({
      descricao: ['', Validators.required],
      fornecedor: [null, Validators.required] // Use 'fornecedor' as the form control name
    });
  }

  produto: ProdutoModel = {
    descricao: '',
    fornecedor: new FornecedorModel()
  };

  searchFornecedors(event: any) {
    this.filteredFornecedors = this.fornecedors.filter(fornecedor =>
      fornecedor?.nomeFornecedor?.toLowerCase().includes(event.query.toLowerCase())
    );

    this.selectedFornecedor = null;
  }

  public salvar() {
    if (this.produtoForm.invalid) {
      return;
    }

    this.produto = { ...this.produto, ...this.produtoForm.value };

    this.produtoService.add(this.produto).subscribe(() => {
      this.router.navigateByUrl('/produtoList');
    });
  }

  cancelar(): void {
    this.router.navigateByUrl('/produtoList');
  }

  onDialogHide(): void {
    this.cancelar();
  }

  private buildForm(): void {
    this.produtoForm = this.formBuilder.group({
      descricao: ['', Validators.required],
      fornecedor: [null, Validators.required] // Use 'fornecedor' as the form control name
    });
  }
}
