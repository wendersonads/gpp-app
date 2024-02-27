import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Message, MessageService } from 'primeng/api';
import { FornecedorModel } from 'src/app/models/FornecedorModel';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { FornecedorService } from 'src/app/services/fornecedor.service';
import { ProdutoService } from 'src/app/services/produto.service';

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
  selector: 'app-produto-edit',
  templateUrl: './produto-edit.component.html',
  styleUrls: ['./produto-edit.component.css']
})
export class ProdutoEditComponent implements OnInit {

  displayDialog: boolean = true;
  fornecedors: FornecedorModel[] = [];
  filteredFornecedors: FornecedorModel[] = [];
  msgs: Message[] = [];
  produtoId!: number;
  pageTitle: string = 'Produto';
  produtoForm: FormGroup;
  selectedFornecedor: FornecedorModel | null = null;

  ngOnInit(): void {
    this.buildForm();

    this.fornecedorService.list().subscribe(fornecedors => {
      this.fornecedors = fornecedors;
    });

    this.route.params.subscribe(params => {
      this.produtoId = params['id'];
      this.loadProduto();
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

  loadProduto(): void {
    this.produtoService.get(this.produtoId).subscribe(produto => {
      this.produto = produto;

      // Update form values with loaded product data
      this.produtoForm.patchValue({
        descricao: produto.descricao,
        fornecedor: produto.fornecedor
      });
    });
  }

  editar(): void {

    if (this.produtoForm.invalid) {
      return;
    }

    this.produto = { ...this.produto, ...this.produtoForm.value };

    this.produtoService.post(this.produto).subscribe(() => {
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
